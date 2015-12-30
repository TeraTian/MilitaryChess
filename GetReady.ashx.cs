using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;

namespace MilitaryChess
{
    /// <summary>
    /// GetReady 的摘要说明
    /// </summary>
    public class GetReady : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            if (context.Request.QueryString["seat"] != null)
            {
                String seat = context.Request.QueryString["seat"];
                String sql = String.Format("update tableready set ready{0} = 1 where id = 1", seat);
                DBUtility.SQLDbHelper.ExecuteSql(sql);
            }

            String sql1 = String.Format("select * from tableready where id =1");
            DataSet ds = DBUtility.SQLDbHelper.Query(sql1);
            DataRow row = ds.Tables[0].Rows[0];
            String[] total = new String[4];
            String result = String.Empty;
            //说明所有玩家都准备好了
            if (row["ready0"].ToString() == "1" && row["ready1"].ToString() == "1" && row["ready2"].ToString() == "1" && row["ready3"].ToString() == "1")
            {
                for (Int32 i = 0; i < 4; i++)
                {
                    String sql2 = String.Format("select * from userposition where userid = '{0}'", row["player" + i].ToString());
                    DataSet ds1 = DBUtility.SQLDbHelper.Query(sql2);
                    DataRow row1 = ds1.Tables[0].Rows[0];
                    total[i] = "\"" + row1["userid"] + "\":" + row1["position"].ToString();
                }
                result = "{\"identity\":0,\"position\":{" + String.Join(",", total) + "},\"seat0\":\"0\",\"seat1\":\"0\",\"seat2\":\"0\",\"seat3\":\"0\"}";
                String sql3 = String.Format("update game set position = '{0}' where id = 1", result);
                DBUtility.SQLDbHelper.ExecuteSql(sql3);
            }
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;

namespace MilitaryChess
{
    /// <summary>
    /// GetPlayerFace 的摘要说明
    /// </summary>
    public class GetPlayerFace : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";

            String sql = "select * from tableready where id=1";
            DataSet ds = DBUtility.SQLDbHelper.Query(sql);
            DataRow row = ds.Tables[0].Rows[0];
            List<String> strlist = new List<String>();
            String result = "[";
            for (Int32 i = 0; i < 4; i++)
            {
                strlist.Add("{\"player\":\"" + row["player" + i] + "\",\"ready\":\"" + row["ready" + i] + "\"}");
            }
            result = result + String.Join(",", strlist) + "]";
            context.Response.Write(result);
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
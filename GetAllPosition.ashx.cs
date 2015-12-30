using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;

namespace MilitaryChess
{
    /// <summary>
    /// GetAllPosition 的摘要说明
    /// </summary>
    public class GetAllPosition : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            String sql = "select * from game where id = 1";
            DataSet ds = DBUtility.SQLDbHelper.Query(sql);
            DataRow row = ds.Tables[0].Rows[0];
            String result = row["position"].ToString();
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
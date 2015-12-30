using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MilitaryChess
{
    /// <summary>
    /// ReSetAll 的摘要说明
    /// </summary>
    public class ReSetAll : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            String sql = "update tableready set ready0 = 0,ready1 = 0,ready0 = 2,ready3 = 0 where id = 1";
            DBUtility.SQLDbHelper.ExecuteSql(sql);
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
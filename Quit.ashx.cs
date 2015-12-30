using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MilitaryChess
{
    /// <summary>
    /// Quit 的摘要说明
    /// </summary>
    public class Quit : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            String seat = context.Request.QueryString["seat"];
            String sql = String.Format("update tableready set player{0} = '',ready{0} = 0 where id = 1", seat);
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
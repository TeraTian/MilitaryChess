using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MilitaryChess
{
    /// <summary>
    /// UpdateNewPosition 的摘要说明
    /// </summary>
    public class UpdateNewPosition : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            String newposition = context.Request.Form["position"];
            String sql = String.Format("update game set position = '{0}' where id = 1", newposition);
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
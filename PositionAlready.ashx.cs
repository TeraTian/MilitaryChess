using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MilitaryChess
{
    /// <summary>
    /// PositionAlready 的摘要说明
    /// </summary>
    public class PositionAlready : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            String player = context.Request.Form["player"];
            String position = context.Request.Form["position"];
            String sql = String.Format("update userposition set position = '{0}' where userid='{1}'", position, player);
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
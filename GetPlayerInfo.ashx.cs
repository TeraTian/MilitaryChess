using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;

namespace MilitaryChess
{
    /// <summary>
    /// GetPlayerInfo 的摘要说明
    /// </summary>
    public class GetPlayerInfo : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            String playerid = context.Request.QueryString["player"];
            String seatid = context.Request.QueryString["seat"];
            String sql = "select * from player where userid='" + playerid + "'";
            DataSet ds = DBUtility.SQLDbHelper.Query(sql);
            DataRow row = ds.Tables[0].Rows[0];
            String result = "{\"img\":\"" + row["img"] + "\",\"nickname\":\"" + row["nickname"] + "\",\"seat\":\""+seatid+"\"}";
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
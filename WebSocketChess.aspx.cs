using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

namespace MilitaryChess
{
    public partial class WebSocketChess : System.Web.UI.Page
    {
        protected String currentseat = String.Empty;
        protected String playerid;
        protected String seatid;
        protected String currentPosition;
        protected String totalplayer;
        protected void Page_Load(object sender, EventArgs e)
        {

            playerid = Request.QueryString["player"];
            seatid = Request.QueryString["seat"];
            currentseat = seatid;
            //将当前玩家放入桌子准备表 tableready中
            NewPlayer(playerid, seatid);

            //获取当前玩家的初始点位
            currentPosition = GetOriginalPosition(playerid);

            //获取当前有哪些玩家
            totalplayer = GetPlayer();


            //String sql = "select * from game where id = 1";
            //DataSet ds = DBUtility.MySQLDbHelper.Query(sql);
            //DataRow row = ds.Tables[0].Rows[0];
            //currentPosition = row["position"].ToString();
        }

        //将当前玩家放入桌子准备表 tableready中
        private void NewPlayer(String playerid, String seatid)
        {
            String sql = String.Format("update tableready set [player{0}]='{1}', [ready{0}]='0' where id=1",
                seatid,
                playerid);
            DBUtility.SQLDbHelper.ExecuteSql(sql);
        }
        //获取当前玩家的初始点位
        private String GetOriginalPosition(String playerid)
        {
            String sql = String.Format("select * from userposition where userid='{0}'", playerid);
            DataSet ds = DBUtility.SQLDbHelper.Query(sql);
            DataRow row = ds.Tables[0].Rows[0];
            String result = "{\"position\":{\"" + playerid + "\":" + row["position"] + "}}";
            return result;
        }
        //获取当前有哪些玩家
        private String GetPlayer()
        {
            String sql = "select * from tableready where id = 1";
            DataSet ds = DBUtility.SQLDbHelper.Query(sql);
            DataRow row = ds.Tables[0].Rows[0];
            String result = row["player0"] + "," + row["player1"] + "," + row["player2"] + "," + row["player3"];
            return result;
        }
    }
}
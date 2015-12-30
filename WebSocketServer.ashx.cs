using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Net.WebSockets;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Web;
using System.Web.WebSockets;

namespace MilitaryChess
{
    /// <summary>
    /// WebSocketServer 的摘要说明
    /// </summary>
    public class WebSocketServer : IHttpHandler
    {
        static Dictionary<string, WebSocket> socketList = new Dictionary<string, WebSocket>();
        public void ProcessRequest(HttpContext context)
        {
            ClearExpiredSocket();
            if (context.IsWebSocketRequest)
            {
                context.AcceptWebSocketRequest(ProcessChat);
            }
        }
        private async Task ProcessChat(AspNetWebSocketContext context)
        {
            using (WebSocket socket = context.WebSocket)
            {
                var key = Guid.NewGuid().ToString();
                socketList.Add(key, socket);
                while (true)
                {
                    ClearExpiredSocket();
                    if (socket.State == WebSocketState.Open)
                    {
                        ArraySegment<byte> buffer = new ArraySegment<byte>(new byte[2048]);
                        WebSocketReceiveResult result = await socket.ReceiveAsync(buffer, CancellationToken.None);
                        string userMsg = Encoding.UTF8.GetString(buffer.Array, 0, result.Count);
                        var responseResult = string.Empty;
                        if (userMsg == "progress1")
                        {
                            responseResult = GetPlayer();
                        }
                        if (userMsg == "progress2")
                        {
                            responseResult = GetAllPosition();
                        }
                        if (responseResult != string.Empty)
                        {
                            buffer = new ArraySegment<byte>(Encoding.UTF8.GetBytes(responseResult));
                            foreach (var s in socketList)
                            {
                                try
                                {
                                    if (s.Value.State == WebSocketState.Open)
                                    {
                                        await s.Value.SendAsync(buffer, WebSocketMessageType.Text, true, CancellationToken.None);
                                    }
                                }
                                catch
                                {
                                }
                            }
                        }
                    }
                    else
                    {
                        break;
                    }
                }
            }
        }

        public void ClearExpiredSocket()
        {
            var keyList = new List<string>();
            foreach (var s in socketList)
            {
                try
                {
                    var state = s.Value.State;
                }
                catch(ObjectDisposedException)
                {
                    keyList.Add(s.Key);
                }
            }
            keyList.ForEach(k => socketList.Remove(k));
        }

        public string GetPlayer()
        {
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
            return result;
        }

        public string GetAllPosition()
        {
            String sql = "select * from game where id = 1";
            DataSet ds = DBUtility.SQLDbHelper.Query(sql);
            DataRow row = ds.Tables[0].Rows[0];
            String result = row["position"].ToString();
            return result;
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
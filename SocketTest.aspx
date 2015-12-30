<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SocketTest.aspx.cs" Inherits="MilitaryChess.SocketTest" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="jquery.js"></script>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
</head>
<body>
    <div>
        <input id="conn" type="button" value="连接" />
        <input id="close" type="button" value="关闭" />
        <span id="tips"></span>
        <input id="content" type="text" />
        <input id="send" type="button" value="发送" />
    </div>
</body>
<script type="text/javascript">
    var ws;
    $().ready(function () {
        $('#conn').click(function () {
            ws = new WebSocket('ws://' + window.location.hostname + ':' + window.location.port + '/WebSocketServer.ashx');
            $('#tips').text('正在连接');
            ws.onopen = function () {
                $('#tips').text('已经连接');
            }
            ws.onmessage = function (evt) {
                $('#tips').text(evt.data);
            }
            ws.onerror = function (evt) {
                $('#tips').text(JSON.stringify(evt));
            }
            ws.onclose = function () {
                $('#tips').text('已经关闭');
            }
        });

        $('#close').click(function () {
            ws.close();
        });

        $('#send').click(function () {
            if (ws.readyState == WebSocket.OPEN) {
                ws.send($('#content').val());
            }
            else {
                $('#tips').text('连接已经关闭');
            }
        });

    });
</script>
</html>

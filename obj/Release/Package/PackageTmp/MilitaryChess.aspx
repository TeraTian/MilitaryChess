<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MilitaryChess.aspx.cs" Inherits="MilitaryChess.MailityChess" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>无标题文档</title>
    <script type="text/javascript" src="jquery.js"></script>
    <style type="text/css">
        .test {
            position: absolute;
        }

        .chess {
            position: absolute;
        }

        #center {
            width: 210px;
            height: 210px;
            top: 235px;
            left: 368px;
        }

        #left {
            width: 219px;
            height: 210px;
            top: 235px;
            left: 149px;
        }

        #top {
            width: 210px;
            height: 219px;
            top: 16px;
            left: 368px;
        }

        #right {
            width: 219px;
            height: 210px;
            top: 235px;
            left: 578px;
        }

        #bottom {
            width: 210px;
            height: 219px;
            top: 445px;
            left: 368px;
        }

        .buttomChess {
            width: 36px;
            height: 27px;
        }

        .leftChess {
            width: 27px;
            height: 36px;
        }

        .chessback {
            z-index: 300;
        }

        .nickname {
            width: 110px;
            height: 30px;
            position: absolute;
            color: White;
            line-height: 30px;
        }

        .headimg {
            width: 120px;
            height: 163px;
            position: absolute;
        }

        .face {
            width: 120px;
            height: 163px;
        }

        #name0 {
            top: 632px;
            left: 586px;
        }

        #player0 {
            top: 464px;
            left: 586px;
        }

        #name1 {
            top: 418px;
            left: 19px;
        }

        #player1 {
            top: 250px;
            left: 19px;
        }

        #name2 {
            top: 188px;
            left: 241px;
        }

        #player2 {
            top: 20px;
            left: 241px;
        }

        #name3 {
            top: 418px;
            left: 816px;
        }

        #player3 {
            top: 250px;
            left: 816px;
        }

        .chosendiv {
            outline: 1px solid white;
        }

        .hide {
            display: none;
        }

        .oldchess {
            z-index: 1000;
        }

        .newchess {
            z-index: 100;
        }

        #timeinterval {
            position: absolute;
            top: 640px;
            left: 720px;
            width: 40px;
            height: 30px;
            border: 1px solid red;
            color: White;
            font-size: 24px;
        }
    </style>
</head>

<body>
    <div id="currentseat" class="hide"><%=currentseat %></div>
    <div id="currentplayer" class="hide"><%=playerid %></div>
    <div id="currentposition" class="hide"></div>
    <div id="totalplayer" class="hide"><%=totalplayer %></div>
    <div id="showtest3">
    </div>
    <div style="position: relative;">
        <div id="timeinterval"></div>
        <div class="headimg" id="player0" seatid=""></div>
        <div class="nickname" id="name0" seatid=""></div>
        <div class="headimg" id="player1" seatid=""></div>
        <div class="nickname" id="name1" seatid=""></div>
        <div class="headimg" id="player2" seatid=""></div>
        <div class="nickname" id="name2" seatid=""></div>
        <div class="headimg" id="player3" seatid=""></div>
        <div class="nickname" id="name3" seatid=""></div>
        <div class="test" id="center">
        </div>
        <div class="test" id="left">
        </div>
        <div class="test" id="top">
        </div>
        <div class="test" id="right">
        </div>
        <div class="test" id="bottom">
        </div>
        <img src="militarychess/ChessBoard.png" />
    </div>
    <input type="button" value="准 备" id="getready" />
    <!--<input type="button" value="退 出" id="quit"/>-->
    <div id="showtest" class="hide">
    </div>
    <div id="showtest2" class="hide" style="border: 1px solid red;">
    </div>
</body>
<script language="javascript" type="text/javascript">
    //棋子对象
    //player 棋子属于哪个玩家
    //chesstype 棋子的种类，司令、军长等
    var chesspieces = function (player, chesstype) {
        this.player = player;
        this.chesstype = chesstype;
    }

    ///////////////////////////////////////////判断需要拐弯的格子//////////////////////////////////
    //4个方向上的增量,仅仅用于下面的方法
    var specialDirection = new Array(new Array(0, -1), new Array(-1, 0), new Array(0, 1), new Array(1, 0));
    //判断拐弯格子的通用方法，仅仅用在specialArray数组中
    function specialFun(row, col, direIndex) {
        var rowadd = specialDirection[direIndex][0];
        var coladd = specialDirection[direIndex][1];
        var temprow = row, tempcol = col;
        while (true) {
            var tempchess = chessboardArray[temprow + rowadd][tempcol + coladd];
            var chesstype = tempchess.type;
            //如果是兵站
            if (chesstype == 1) {
                //如果没棋
                if (tempchess.haspieces == 0) {
                    effectiveArray.push(new Array(temprow + rowadd, tempcol + coladd));
                    temprow = temprow + rowadd;
                    tempcol = tempcol + coladd;
                }
                    //说明有棋
                else {
                    //如果不是友方的棋子
                    if (tempchess.chesspieces.player != playerArray[playerDirectionArray[0]] && tempchess.chesspieces.player != playerArray[playerDirectionArray[2]]) {
                        effectiveArray.push(new Array(temprow + rowadd, tempcol + coladd));
                        break
                    }
                        //是友方的棋子
                    else {
                        break;
                    }
                }
            }
                //不是兵站
            else {
                break;
            }
        }
    }
    //针对8处拐弯判断的方法数组
    var specialArray = new Array(
    //不需要判断
        function () {
        },
    //右下角，向上
        function () {
            specialFun(10, 10, 2);
        },
    //右下角，向左
        function () {
            specialFun(10, 10, 3);
        },
    //右上角，向左
        function () {
            specialFun(6, 10, 1);
        },
    //右上角，向下
        function () {
            specialFun(6, 10, 2);
        },
    //左上角，向下
        function () {
            specialFun(6, 6, 0);
        },
    //左上角，向右
        function () {
            specialFun(6, 6, 1);
        },
    //左下角，向右
        function () {
            specialFun(10, 6, 3);
        },
    //左下角，向上
        function () {
            specialFun(10, 6, 0);
        }
        );
    ///////////////////////////////////////////判断需要拐弯的格子//////////////////////////////////


    //不同类型棋盘格子判断有效落子点位的方法数组
    var checkMethodArray = new Array(
    //0 中间区域的兵站之间的格子,什么都不用做
        function (row, col) {
        },
    //1 铁道上的兵站，最复杂的判断
        function (row, col) {
            //先判断左上，右上，左下，右下 4个方向
            var temparray = new Array(new Array(row - 1, col - 1), new Array(row - 1, col + 1), new Array(row + 1, col - 1), new Array(row + 1, col + 1));
            for (var i = 0; i < temparray.length; i++) {
                var tempchess = chessboardArray[temparray[i][0]][temparray[i][1]];
                //如果是营,并且其中没有棋子
                if (tempchess.type == 2 && tempchess.haspieces == 0) {
                    effectiveArray.push(temparray[i]);
                }
            }

            //用来标记转弯方式
            var special = 0;
            //是不是点击的是特殊位置，需要额外判断转弯格子
            if (row == 11 && col == 10) { special = 1; }
            if (row == 10 && col == 11) { special = 2; }
            if (row == 6 && col == 11) { special = 3; }
            if (row == 5 && col == 10) { special = 4; }
            if (row == 5 && col == 6) { special = 5; }
            if (row == 6 && col == 5) { special = 6; }
            if (row == 10 && col == 5) { special = 7; }
            if (row == 11 && col == 6) { special = 8; }

            //判断上下左右4个方向
            //这个数组表示的是行与列的增量，从而可以一路判断过去
            var temparray = new Array(new Array(0, -1), new Array(-1, 0), new Array(0, 1), new Array(1, 0));
            for (var i = 0; i < temparray.length; i++) {
                var rowadd = temparray[i][0];
                var coladd = temparray[i][1];
                var temprow = row;
                var tempcol = col;
                //用来标记是否经过了兵站，经过的话，就不能再进入营等地方了
                var flag = 0;
                //用迭代去不停遍历，而不是递归
                while (true) {
                    //如果判断到特殊位置，并且方向也正确，特殊位置上没有棋子的话，那就要判断额外的转弯格子
                    if ((temprow + rowadd) == 11 && (tempcol + coladd) == 10 && i == 1 && chessboardArray[temprow + rowadd][tempcol + coladd].haspieces == 0) { special = 1; }
                    if ((temprow + rowadd) == 10 && (tempcol + coladd) == 11 && i == 0 && chessboardArray[temprow + rowadd][tempcol + coladd].haspieces == 0) { special = 2; }
                    if ((temprow + rowadd) == 6 && (tempcol + coladd) == 11 && i == 0 && chessboardArray[temprow + rowadd][tempcol + coladd].haspieces == 0) { special = 3; }
                    if ((temprow + rowadd) == 5 && (tempcol + coladd) == 10 && i == 3 && chessboardArray[temprow + rowadd][tempcol + coladd].haspieces == 0) { special = 4; }
                    if ((temprow + rowadd) == 5 && (tempcol + coladd) == 6 && i == 3 && chessboardArray[temprow + rowadd][tempcol + coladd].haspieces == 0) { special = 5; }
                    if ((temprow + rowadd) == 6 && (tempcol + coladd) == 5 && i == 2 && chessboardArray[temprow + rowadd][tempcol + coladd].haspieces == 0) { special = 6; }
                    if ((temprow + rowadd) == 10 && (tempcol + coladd) == 5 && i == 2 && chessboardArray[temprow + rowadd][tempcol + coladd].haspieces == 0) { special = 7; }
                    if ((temprow + rowadd) == 11 && (tempcol + coladd) == 6 && i == 1 && chessboardArray[temprow + rowadd][tempcol + coladd].haspieces == 0) { special = 8; }

                    var chesstype = chessboardArray[temprow + rowadd][tempcol + coladd].type;
                    //如果是-1，说明没路走了
                    if (chesstype == -1) {
                        break;
                    }
                        //如果是0，就跳过这一格，继续判断下一格
                    else if (chesstype == 0) {
                        temprow = temprow + rowadd;
                        tempcol = tempcol + coladd;
                    }
                        //如果不是-1，就说明是只能走一步的地方
                    else if (chesstype != 1) {
                        var tempchess = chessboardArray[temprow + rowadd][tempcol + coladd];
                        //如果没有经过兵站，那就说明可以走
                        if (flag == 0) {
                            //是营
                            if (tempchess.type == 2) {
                                //如果其中没有棋子
                                if (tempchess.haspieces == 0) {
                                    effectiveArray.push(new Array(temprow + rowadd, tempcol + coladd));
                                }
                            }
                                //不是营
                            else {
                                //如果不是友方的棋子
                                if (tempchess.chesspieces.player != playerArray[playerDirectionArray[0]] && tempchess.chesspieces.player != playerArray[playerDirectionArray[2]]) {
                                    effectiveArray.push(new Array(temprow + rowadd, tempcol + coladd));
                                }
                            }
                        }
                        break;
                    }
                        //说明是兵站，先改变flag，然后判断棋格上是否有棋子
                    else {
                        var tempchess = chessboardArray[temprow + rowadd][tempcol + coladd];
                        flag = 1;
                        //如果该棋格上有棋子，那就不能继续往下走了
                        if (chessboardArray[temprow + rowadd][tempcol + coladd].haspieces == 1) {
                            //如果不是友方的棋子
                            if (tempchess.chesspieces.player != playerArray[playerDirectionArray[0]] && tempchess.chesspieces.player != playerArray[playerDirectionArray[2]]) {
                                effectiveArray.push(new Array(temprow + rowadd, tempcol + coladd));
                                break
                            }
                                //是友方的棋子
                            else {
                                break;
                            }
                        }
                            //没有棋子
                        else {
                            effectiveArray.push(new Array(temprow + rowadd, tempcol + coladd));
                        }
                        temprow = temprow + rowadd;
                        tempcol = tempcol + coladd;
                    }
                }

                //判断拐弯的棋子
                specialArray[special]();
            }
        },
    //2 营 周围八个格子
        function (row, col) {
            for (var i = row - 1; i <= row + 1; i++) {
                for (var j = col - 1; j <= col + 1; j++) {
                    if (i != row || j != col) {
                        var tempchess = chessboardArray[i][j];
                        //如果判断的格子是营
                        if (tempchess.type == 2) {
                            //如果其中没有棋子
                            if (tempchess.haspieces == 0) {
                                effectiveArray.push(new Array(i, j));
                            }
                        }
                            //如果不是营
                        else {
                            //如果没有棋子
                            if (tempchess.haspieces == 0) {
                                effectiveArray.push(new Array(i, j));
                            }
                                //有棋子，但是不是己方的棋子
                            else if (tempchess.chesspieces.player != playerArray[playerDirectionArray[0]] && tempchess.chesspieces.player != playerArray[playerDirectionArray[2]]) {
                                effectiveArray.push(new Array(i, j));
                            }
                        }
                    }
                }
            }
        },
    //3 最中间营上下左右的四个兵站 上下左右4个
        function (row, col) {
            var temparray = new Array(new Array(row, col - 1), new Array(row, col + 1), new Array(row - 1, col), new Array(row + 1, col));
            for (var i = 0; i < temparray.length; i++) {
                var tempchess = chessboardArray[temparray[i][0]][temparray[i][1]];
                //如果判断的格子是营
                if (tempchess.type == 2) {
                    //如果其中没有棋子
                    if (tempchess.haspieces == 0) {
                        effectiveArray.push(temparray[i]);
                    }
                }
                    //如果不是营
                else {
                    //如果没有棋子
                    if (tempchess.haspieces == 0) {
                        effectiveArray.push(temparray[i]);
                    }
                        //有棋子，但是不是己方的棋子
                    else if (tempchess.chesspieces.player != playerArray[playerDirectionArray[0]] && tempchess.chesspieces.player != playerArray[playerDirectionArray[2]]) {
                        effectiveArray.push(temparray[i]);
                    }
                }
            }
        },
    //4 最下层的3个兵站 判断上下左右4个方向，能落子的格子
        function (row, col) {
            //将4个点位放入数组方便循环
            var temparray = new Array(new Array(row, col - 1), new Array(row, col + 1), new Array(row - 1, col), new Array(row + 1, col));
            for (var i = 0; i < temparray.length; i++) {
                //判断的格子在整个棋盘之内
                if (temparray[i][0] >= 0 && temparray[i][0] <= 16 && temparray[i][1] >= 0 && temparray[i][1] <= 16) {
                    var tempchessboard = chessboardArray[temparray[i][0]][temparray[i][1]];
                    //判断的格子的type不是-1，并且不是自己或者对面的棋子，说明是可以落子的
                    if (tempchessboard.type != -1 && tempchessboard.chesspieces.player != playerArray[playerDirectionArray[0]] && tempchessboard.chesspieces.player != playerArray[playerDirectionArray[2]]) {
                        effectiveArray.push(temparray[i]);
                    }
                }
            }
        },
    //5 放军旗的两个格子 什么都不用做
        function (row, col) {
        });

    //棋盘对象
    //chesspieces 棋盘上的棋子
    //type 棋盘格子的类型，包括铁道上的兵站，营等
    //     -1 无法落子的格子
    //      0 中间区域的兵站之间的格子
    //      1 铁道上的兵站
    //      2 营
    //      3 最中间营上下左右的四个兵站
    //      4 最下层的3个兵站
    //      5 放军旗的两个格子
    //haspieces 当前棋盘格子上是否有棋子
    var chessboard = function (chesspieces, type, haspieces) {
        this.chesspieces = chesspieces;
        this.type = type;
        this.haspieces = haspieces;
        this.checkmethod = function (row, col) {
            effectiveArray = new Array();
            //如果不是工兵
            if (this.type != -1 && this.type != 0 && this.chesspieces.chesstype != 9) {
                //判断哪些点位是可以落子的
                checkMethodArray[type](row, col);
                $(".chessback").css("backgroundColor", "transparent");
                for (var i = 0; i < effectiveArray.length; i++) {
                    $(".chessback").filter(function (index) {
                        return $(this).attr("row") == effectiveArray[i][0] && $(this).attr("col") == effectiveArray[i][1];
                    }).css("backgroundColor", "red");
                    $(".chessback").filter(function (index) {
                        return $(this).attr("row") == effectiveArray[i][0] && $(this).attr("col") == effectiveArray[i][1];
                    }).fadeTo(0, 0.3);
                }
            }
            //如果点击的是工兵
            if (this.type != -1 && this.type != 0 && this.chesspieces.chesstype == 9) {
                //如果在铁道上
                if (this.type == 1) {
                    //方向数组
                    var diarray = new Array(new Array(0, -1), new Array(-1, 0), new Array(0, 1), new Array(1, 0));
                    for (var i = 0; i < 4; i++) {
                        var temprow = row + diarray[i][0];
                        var tempcol = col + diarray[i][1];
                        var tempchess = chessboardArray[temprow][tempcol];
                        //如果是在铁道中间，就多往前算一格
                        if (tempchess.type == 0) {
                            temprow = temprow + diarray[i][0];
                            tempcol = tempcol + diarray[i][1];
                            tempchess = chessboardArray[temprow][tempcol];
                        }
                        //如果判断的格子是在铁道上
                        if (tempchess.type == 1) {
                            //如果有棋子
                            if (tempchess.haspieces == 1) {
                                //如果不是友方的棋子
                                if (tempchess.chesspieces.player != playerArray[playerDirectionArray[0]] && tempchess.chesspieces.player != playerArray[playerDirectionArray[2]]) {
                                    effectiveArray.push(new Array(temprow, tempcol));
                                }
                            }
                            else {
                                checkGongBing(temprow, tempcol);
                                //effectiveArray.push(new Array(temprow, tempcol));
                            }
                        }
                    }
                }
                //按照其他棋子的步骤再计算一边
                checkMethodArray[type](row, col);
                //alert(effectiveArray.length);
                $(".chessback").css("backgroundColor", "transparent");
                for (var i = 0; i < effectiveArray.length; i++) {
                    $(".chessback").filter(function (index) {
                        return $(this).attr("row") == effectiveArray[i][0] && $(this).attr("col") == effectiveArray[i][1];
                    }).css("backgroundColor", "red");
                    $(".chessback").filter(function (index) {
                        return $(this).attr("row") == effectiveArray[i][0] && $(this).attr("col") == effectiveArray[i][1];
                    }).fadeTo(0, 0.3);
                }
            }
        }
    }
    function checkGongBing(row, col) {
        //到这一步，说明检查的位置是没有棋子的，肯定符合要求
        effectiveArray.push(new Array(row, col));
        //方向数组
        var diarray = new Array(new Array(0, -1), new Array(-1, 0), new Array(0, 1), new Array(1, 0));
        for (var i = 0; i < 4; i++) {
            var temprow = row + diarray[i][0];
            var tempcol = col + diarray[i][1];
            var tempchess = chessboardArray[temprow][tempcol];
            //如果是在铁道中间，就多往前算一格
            if (tempchess.type == 0) {
                temprow = temprow + diarray[i][0];
                tempcol = tempcol + diarray[i][1];
                tempchess = chessboardArray[temprow][tempcol];
            }
            //如果判断的格子在铁道上
            if (tempchess.type == 1) {
                //如果已经保存过了那就不要再计算了
                //检测是否已经被收录了
                var flag = 0;
                for (var j = 0; j < effectiveArray.length; j++) {
                    //alert("j:" + j + " temprow:" + temprow + " tempcol:" + tempcol + " effrow:" + effectiveArray[j][0] + " effcol:" + effectiveArray[j][1]);
                    if (temprow == effectiveArray[j][0] && tempcol == effectiveArray[j][1]) {
                        flag = 1;
                    }
                }
                //如果还没被收录
                if (flag == 0) {
                    //如果有棋子                
                    if (tempchess.haspieces == 1) {
                        //如果不是友方的棋子
                        if (tempchess.chesspieces.player != playerArray[playerDirectionArray[0]] && tempchess.chesspieces.player != playerArray[playerDirectionArray[2]]) {
                            effectiveArray.push(new Array(temprow, tempcol));
                        }
                    }
                    else {
                        //进行递归的判断
                        checkGongBing(temprow, tempcol);
                    }
                }
            }
        }
    }

    var chessboardArray = new Array(
    //0
        new Array(new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, 4, 0), new chessboard(null, 5, 0), new chessboard(null, 4, 0), new chessboard(null, 5, 0), new chessboard(null, 4, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0)),
    //1
		new Array(new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, 1, 0), new chessboard(null, 1, 0), new chessboard(null, 1, 0), new chessboard(null, 1, 0), new chessboard(null, 1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0)),
    //2
		new Array(new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, 1, 0), new chessboard(null, 2, 0), new chessboard(null, 3, 0), new chessboard(null, 2, 0), new chessboard(null, 1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0)),
    //3
		new Array(new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, 1, 0), new chessboard(null, 3, 0), new chessboard(null, 2, 0), new chessboard(null, 3, 0), new chessboard(null, 1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0)),
    //4
		new Array(new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, 1, 0), new chessboard(null, 2, 0), new chessboard(null, 3, 0), new chessboard(null, 2, 0), new chessboard(null, 1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0)),
    //5
		new Array(new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, 1, 0), new chessboard(null, 1, 0), new chessboard(null, 1, 0), new chessboard(null, 1, 0), new chessboard(null, 1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0)),
    //6
        new Array(new chessboard(null, 4, 0), new chessboard(null, 1, 0), new chessboard(null, 1, 0), new chessboard(null, 1, 0), new chessboard(null, 1, 0), new chessboard(null, 1, 0), new chessboard(null, 1, 0), new chessboard(null, 0, 0), new chessboard(null, 1, 0), new chessboard(null, 0, 0), new chessboard(null, 1, 0), new chessboard(null, 1, 0), new chessboard(null, 1, 0), new chessboard(null, 1, 0), new chessboard(null, 1, 0), new chessboard(null, 1, 0), new chessboard(null, 4, 0)),
    //7
        new Array(new chessboard(null, 5, 0), new chessboard(null, 1, 0), new chessboard(null, 2, 0), new chessboard(null, 3, 0), new chessboard(null, 2, 0), new chessboard(null, 1, 0), new chessboard(null, 0, 0), new chessboard(null, -1, 0), new chessboard(null, 0, 0), new chessboard(null, -1, 0), new chessboard(null, 0, 0), new chessboard(null, 1, 0), new chessboard(null, 2, 0), new chessboard(null, 3, 0), new chessboard(null, 2, 0), new chessboard(null, 1, 0), new chessboard(null, 5, 0)),
    //8
        new Array(new chessboard(null, 4, 0), new chessboard(null, 1, 0), new chessboard(null, 3, 0), new chessboard(null, 2, 0), new chessboard(null, 3, 0), new chessboard(null, 1, 0), new chessboard(null, 1, 0), new chessboard(null, 0, 0), new chessboard(null, 1, 0), new chessboard(null, 0, 0), new chessboard(null, 1, 0), new chessboard(null, 1, 0), new chessboard(null, 3, 0), new chessboard(null, 2, 0), new chessboard(null, 3, 0), new chessboard(null, 1, 0), new chessboard(null, 4, 0)),
    //9
        new Array(new chessboard(null, 5, 0), new chessboard(null, 1, 0), new chessboard(null, 2, 0), new chessboard(null, 3, 0), new chessboard(null, 2, 0), new chessboard(null, 1, 0), new chessboard(null, 0, 0), new chessboard(null, -1, 0), new chessboard(null, 0, 0), new chessboard(null, -1, 0), new chessboard(null, 0, 0), new chessboard(null, 1, 0), new chessboard(null, 2, 0), new chessboard(null, 3, 0), new chessboard(null, 2, 0), new chessboard(null, 1, 0), new chessboard(null, 5, 0)),
    //10
        new Array(new chessboard(null, 4, 0), new chessboard(null, 1, 0), new chessboard(null, 1, 0), new chessboard(null, 1, 0), new chessboard(null, 1, 0), new chessboard(null, 1, 0), new chessboard(null, 1, 0), new chessboard(null, 0, 0), new chessboard(null, 1, 0), new chessboard(null, 0, 0), new chessboard(null, 1, 0), new chessboard(null, 1, 0), new chessboard(null, 1, 0), new chessboard(null, 1, 0), new chessboard(null, 1, 0), new chessboard(null, 1, 0), new chessboard(null, 4, 0)),
    //11
		new Array(new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, 1, 0), new chessboard(null, 1, 0), new chessboard(null, 1, 0), new chessboard(null, 1, 0), new chessboard(null, 1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0)),
    //12
		new Array(new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, 1, 0), new chessboard(null, 2, 0), new chessboard(null, 3, 0), new chessboard(null, 2, 0), new chessboard(null, 1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0)),
    //13
		new Array(new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, 1, 0), new chessboard(null, 3, 0), new chessboard(null, 2, 0), new chessboard(null, 3, 0), new chessboard(null, 1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0)),
    //14
		new Array(new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, 1, 0), new chessboard(null, 2, 0), new chessboard(null, 3, 0), new chessboard(null, 2, 0), new chessboard(null, 1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0)),
    //15
		new Array(new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, 1, 0), new chessboard(null, 1, 0), new chessboard(null, 1, 0), new chessboard(null, 1, 0), new chessboard(null, 1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0)),
    //16
        new Array(new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, 4, 0), new chessboard(null, 5, 0), new chessboard(null, 4, 0), new chessboard(null, 5, 0), new chessboard(null, 4, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0), new chessboard(null, -1, 0))
    );

    //画出测试棋盘的类型
    for (var i = 0; i < 17; i++) {
        for (var j = 0; j < 17; j++) {
            $("#showtest").append($("<div style='width:25px;height:25px;float:left;text-align:center;'>" + chessboardArray[i][j].type + "</div>"));
        }
        $("#showtest").append($("<div style='clear:both;'></div>"));
    }

    //存放图片的文件夹名
    var imgfile = "militarychess";

    //五个部分的坐标位置数组
    var bottomPosition = new Array(); //底部坐标数组
    var leftPosition = new Array(); //左边坐标数组
    var rightPosition = new Array(); //右边坐标数组
    var topPosition = new Array(); //顶部坐标数组
    var centerPosition = new Array(); //中部坐标数组

    //坐标数组，用来通过循环确定使用哪个坐标
    var positionArray = new Array(bottomPosition, leftPosition, topPosition, rightPosition);

    //div数组，用来通过循环确定添加到哪个div中
    var divArray = new Array($("#bottom"), $("#left"), $("#top"), $("#right"));

    //棋子数组，每一个数组下标对应一种棋的图片名称，方便于图片显示
    var chessArray = new Array("zhadan", "siling", "junzhang", "shizhang", "lvzhang", "tuanzhang", "yingzhang", "lianzhang", "paizhang", "gongbing", "dilei", "junqi");

    //方向数组,此数组不与上面玩家标识对应，仅仅用于方便图片的显示
    var directionArray = new Array("", "l", "", "r");

    //数组转换公式数组，在绘制棋子时用eval函数转换
    //详细说明：
    //本来是作两维数组进行转换，但是由于json作两维数组比较麻烦，所以现在变为两个一维数组进行转换
    //若原先的下标为 x ,转换后的下标为 i
    //底部：不需要进行旋转，所以 i = x
    //左边：需要顺势针旋转90度，所以 i = (x % col) * row + ( row - 1 - parseInt(x / col))   这里必须用parseInt,因为要取整
    //对面：顺时针旋转180度，所以 i = col * row - 1 - x
    //右边：逆时针旋转90度，所以 i = (col - 1 - x % col) * row + parseInt(x / col)
    var row = 6, col = 5;
    var changeArray = new Array(
        "i = x",
        "i = (x % " + col + ")*" + row + "+ (" + row + "- 1 - parseInt(x / " + col + "))",
        "i = " + (row * col - 1) + " - x",
        "i = (" + col + " - 1 - x % " + col + ") * " + row + " + parseInt(x / " + col + ")");

    //将点位数组与最大的棋盘点位数组对应起来
    var changeArray2 = new Array(
        new Array("m = parseInt(i / " + col + ") + 11", "n = i % " + col + " + 6"),
        new Array("m = parseInt(i / " + row + ") + 6", "n = i % " + row),
        new Array("m = parseInt(i / " + col + ")", "n = i % " + col + " + 6"),
        new Array("m = parseInt(i / " + row + ") + 6", "n = i % " + row + " + 11"),
        new Array("m = 2 * parseInt((x - 30) / 3) + 6", "n = 2 * ((x - 30) % 3) + 6")
    );

    ///////////////////////下面3个数组相互关联//////////////////////////////
    //背景图片数组
    var backArray = new Array("ChessmanB", "ChessmanG", "ChessmanO", "ChessmanP");
    //玩家id数组
    var totalplayer = $("#totalplayer").text();
    var playerArray = totalplayer.split(",");

    //玩家位置数组，下标0表示自己，下标1表示左边，下标2表示对面，下标3表示右边
    //数组的值对应playerArray数组的下标 和 backArray数组的下标，表示玩家的id和对应的颜色
    //通过修改这个数组，来改变棋子视角的转换
    var playerDirectionArray = new Array(0, 1, 2, 3);
    ////////////////////////////////////////////////////////////////////////

    //整个棋盘背景的点位数组
    var wholePositionArray = new Array();

    drawChessBoardDiv();
    //绘制整个棋盘div
    function drawChessBoardDiv() {
        bottomPosition.splice(0, bottomPosition.length); //底部坐标数组
        leftPosition.length = 0; //左边坐标数组
        rightPosition.length = 0; //右边坐标数组
        topPosition.length = 0; //顶部坐标数组
        centerPosition.length = 0; //中间坐标数组
        //上下位置的棋谱坐标
        for (var i = 0; i < 6; i++) {
            for (var j = 0; j < 5; j++) {
                var tempdiv = $("<div class='buttomChess test chessback' row='" + (11 + i) + "' col='" + (6 + j) + "'  style='top:" + (i * 39 - 2) + "px;left:" + (j * 40 + 7) + "px;'></div>");
                $("#bottom").append(tempdiv);
                var tempdiv = $("<div class='buttomChess test chessback' row='" + i + "' col='" + (6 + j) + "' style='top:" + (i * 39 - 2) + "px;left:" + (j * 40 + 7) + "px;'></div>");
                $("#top").append(tempdiv);
                bottomPosition.push(new Array(i * 39 - 2, j * 40 + 7));
                topPosition.push(new Array(i * 39 - 2, j * 40 + 7));
            }
        }
        //左右位置的棋谱坐标
        for (var i = 0; i < 5; i++) {
            for (var j = 0; j < 6; j++) {
                var tempdiv = $("<div class='leftChess test chessback' row='" + (6 + i) + "' col='" + (11 + j) + "'  style='top:" + (i * 40 + 7) + "px;left:" + (j * 39 - 2) + "px;'></div>");
                $("#right").append(tempdiv);
                var tempdiv = $("<div class='leftChess test chessback' row='" + (6 + i) + "' col='" + j + "' style='top:" + (i * 40 + 7) + "px;left:" + (j * 39 - 2) + "px;'></div>");
                $("#left").append(tempdiv);
                leftPosition.push(new Array(i * 40 + 7, j * 39 - 2));
                rightPosition.push(new Array(i * 40 + 7, j * 39 - 2));
            }
        }

        //中间位置的棋谱坐标
        for (var i = 0; i < 3; i++) {
            for (var j = 0; j < 3; j++) {
                var tempdiv = $("<div class='buttomChess test chessback' row='" + (6 + i * 2) + "' col='" + (6 + j * 2) + "' style='top:" + (i * 76 + 15) + "px;left:" + (j * 80 + 7) + "px;'></div>");
                $("#center").append(tempdiv);
                centerPosition.push(new Array(i * 76 + 15, j * 80 + 7));
            }
        }
        //设置初始的键盘点击事件
        SetDivClickType0();
    }
    //设置div的透明度
    //$(".test").fadeTo(0, 0.3);

    //当前可以落子的格子
    var effectiveArray = new Array();
    //是否“拿起”了一个棋子
    var isChessLifted = null;




    //获取的JSON格式数据
    //因为数据太长容易瞎眼，所以先分成几部分做拼接
    //    var positionjf = '{"identity":1,"position":{';
    //    var positionj1 = '"p1111":[{"id":"p1111","type":"1"},{"id":"p1111","type":"2"},{"id":"p1111","type":"3"},{"id":"p1111","type":"3"},{"id":"p1111","type":"4"},{"id":"p1111","type":"4"},{"id":"p1111","type":"-1"},{"id":"p1111","type":"5"},{"id":"p1111","type":"-1"},{"id":"p1111","type":"5"},{"id":"p1111","type":"6"},{"id":"p1111","type":"6"},{"id":"p1111","type":"-1"},{"id":"p1111","type":"7"},{"id":"p1111","type":"7"},{"id":"p1111","type":"7"},{"id":"p1111","type":"-1"},{"id":"p1111","type":"8"},{"id":"p1111","type":"-1"},{"id":"p1111","type":"8"},{"id":"p1111","type":"10"},{"id":"p1111","type":"10"},{"id":"p1111","type":"10"},{"id":"p1111","type":"9"},{"id":"p1111","type":"9"},{"id":"p1111","type":"0"},{"id":"p1111","type":"11"},{"id":"p1111","type":"9"},{"id":"p1111","type":"8"},{"id":"p1111","type":"0"},{"id":"p1111","type":"-1"},{"id":"p1111","type":"-1"},{"id":"p1111","type":"-1"},{"id":"p1111","type":"-1"},{"id":"p1111","type":"-1"},{"id":"p1111","type":"-1"},{"id":"p1111","type":"-1"},{"id":"p1111","type":"-1"},{"id":"p1111","type":"-1"}],';
    //    var positionj2 = '"p2222":[{"id":"p2222","type":"1"},{"id":"p2222","type":"2"},{"id":"p2222","type":"3"},{"id":"p2222","type":"3"},{"id":"p2222","type":"4"},{"id":"p2222","type":"4"},{"id":"p2222","type":"-1"},{"id":"p2222","type":"5"},{"id":"p2222","type":"-1"},{"id":"p2222","type":"5"},{"id":"p2222","type":"6"},{"id":"p2222","type":"6"},{"id":"p2222","type":"-1"},{"id":"p2222","type":"7"},{"id":"p2222","type":"7"},{"id":"p2222","type":"7"},{"id":"p2222","type":"-1"},{"id":"p2222","type":"8"},{"id":"p2222","type":"-1"},{"id":"p2222","type":"8"},{"id":"p2222","type":"10"},{"id":"p2222","type":"10"},{"id":"p2222","type":"10"},{"id":"p2222","type":"9"},{"id":"p2222","type":"9"},{"id":"p2222","type":"0"},{"id":"p2222","type":"11"},{"id":"p2222","type":"9"},{"id":"p2222","type":"8"},{"id":"p2222","type":"0"},{"id":"p2222","type":"-1"},{"id":"p2222","type":"-1"},{"id":"p2222","type":"-1"},{"id":"p2222","type":"-1"},{"id":"p2222","type":"-1"},{"id":"p2222","type":"-1"},{"id":"p2222","type":"-1"},{"id":"p2222","type":"-1"},{"id":"p2222","type":"-1"}],';
    //    var positionj3 = '"p3333":[{"id":"p3333","type":"1"},{"id":"p3333","type":"2"},{"id":"p3333","type":"3"},{"id":"p3333","type":"3"},{"id":"p3333","type":"4"},{"id":"p3333","type":"4"},{"id":"p3333","type":"-1"},{"id":"p3333","type":"5"},{"id":"p3333","type":"-1"},{"id":"p3333","type":"5"},{"id":"p3333","type":"6"},{"id":"p3333","type":"6"},{"id":"p3333","type":"-1"},{"id":"p3333","type":"7"},{"id":"p3333","type":"7"},{"id":"p3333","type":"7"},{"id":"p3333","type":"-1"},{"id":"p3333","type":"8"},{"id":"p3333","type":"-1"},{"id":"p3333","type":"8"},{"id":"p3333","type":"10"},{"id":"p3333","type":"10"},{"id":"p3333","type":"10"},{"id":"p3333","type":"9"},{"id":"p3333","type":"9"},{"id":"p3333","type":"0"},{"id":"p3333","type":"11"},{"id":"p3333","type":"9"},{"id":"p3333","type":"8"},{"id":"p3333","type":"0"},{"id":"p3333","type":"-1"},{"id":"p3333","type":"-1"},{"id":"p3333","type":"-1"},{"id":"p3333","type":"-1"},{"id":"p3333","type":"-1"},{"id":"p3333","type":"-1"},{"id":"p3333","type":"-1"},{"id":"p3333","type":"-1"},{"id":"p3333","type":"-1"}],';
    //    var positionj4 = '"p4444":[{"id":"p4444","type":"1"},{"id":"p4444","type":"2"},{"id":"p4444","type":"3"},{"id":"p4444","type":"3"},{"id":"p4444","type":"4"},{"id":"p4444","type":"4"},{"id":"p4444","type":"-1"},{"id":"p4444","type":"5"},{"id":"p4444","type":"-1"},{"id":"p4444","type":"5"},{"id":"p4444","type":"6"},{"id":"p4444","type":"6"},{"id":"p4444","type":"-1"},{"id":"p4444","type":"7"},{"id":"p4444","type":"7"},{"id":"p4444","type":"7"},{"id":"p4444","type":"-1"},{"id":"p4444","type":"8"},{"id":"p4444","type":"-1"},{"id":"p4444","type":"8"},{"id":"p4444","type":"10"},{"id":"p4444","type":"10"},{"id":"p4444","type":"10"},{"id":"p4444","type":"9"},{"id":"p4444","type":"9"},{"id":"p4444","type":"0"},{"id":"p4444","type":"11"},{"id":"p4444","type":"9"},{"id":"p4444","type":"8"},{"id":"p4444","type":"0"},{"id":"p4444","type":"-1"},{"id":"p4444","type":"-1"},{"id":"p4444","type":"-1"},{"id":"p4444","type":"-1"},{"id":"p4444","type":"-1"},{"id":"p4444","type":"-1"},{"id":"p4444","type":"-1"},{"id":"p4444","type":"-1"},{"id":"p4444","type":"-1"}]';
    //    var positionjl = '}}';

    //var positionJSON = '{"identity":1,"position":{"p4444":[{"id":"p1111","type":"1"},{"id":"p1111","type":"2"},{"id":"p1111","type":"3"},{"id":"p1111","type":"3"},{"id":"p1111","type":"4"},{"id":"p1111","type":"4"},{"id":"p1111","type":"-1"},{"id":"p1111","type":"0"},{"id":"p1111","type":"-1"},{"id":"p1111","type":"0"},{"id":"p1111","type":"6"},{"id":"p1111","type":"6"},{"id":"p1111","type":"-1"},{"id":"p1111","type":"7"},{"id":"p1111","type":"7"},{"id":"p1111","type":"7"},{"id":"p1111","type":"-1"},{"id":"p1111","type":"8"},{"id":"p1111","type":"-1"},{"id":"p1111","type":"8"},{"id":"p1111","type":"10"},{"id":"p1111","type":"10"},{"id":"p1111","type":"10"},{"id":"p1111","type":"9"},{"id":"p1111","type":"9"},{"id":"p1111","type":"5"},{"id":"p1111","type":"11"},{"id":"p1111","type":"9"},{"id":"p1111","type":"8"},{"id":"p1111","type":"5"}],"p2222":[{"id":"p2222","type":"1"},{"id":"p2222","type":"2"},{"id":"p2222","type":"3"},{"id":"p2222","type":"3"},{"id":"p2222","type":"4"},{"id":"p2222","type":"4"},{"id":"p2222","type":"-1"},{"id":"p2222","type":"0"},{"id":"p2222","type":"-1"},{"id":"p2222","type":"0"},{"id":"p2222","type":"6"},{"id":"p2222","type":"6"},{"id":"p2222","type":"-1"},{"id":"p2222","type":"7"},{"id":"p2222","type":"7"},{"id":"p2222","type":"7"},{"id":"p2222","type":"-1"},{"id":"p2222","type":"8"},{"id":"p2222","type":"-1"},{"id":"p2222","type":"8"},{"id":"p2222","type":"10"},{"id":"p2222","type":"10"},{"id":"p2222","type":"10"},{"id":"p2222","type":"9"},{"id":"p2222","type":"9"},{"id":"p2222","type":"5"},{"id":"p2222","type":"11"},{"id":"p2222","type":"9"},{"id":"p2222","type":"8"},{"id":"p2222","type":"5"}],"p3333":[{"id":"p2222","type":"1"},{"id":"p2222","type":"2"},{"id":"p2222","type":"3"},{"id":"p2222","type":"3"},{"id":"p2222","type":"4"},{"id":"p2222","type":"4"},{"id":"p2222","type":"-1"},{"id":"p2222","type":"0"},{"id":"p2222","type":"-1"},{"id":"p2222","type":"0"},{"id":"p2222","type":"6"},{"id":"p2222","type":"6"},{"id":"p2222","type":"-1"},{"id":"p2222","type":"7"},{"id":"p2222","type":"7"},{"id":"p2222","type":"7"},{"id":"p2222","type":"-1"},{"id":"p2222","type":"8"},{"id":"p2222","type":"-1"},{"id":"p2222","type":"8"},{"id":"p2222","type":"10"},{"id":"p2222","type":"10"},{"id":"p2222","type":"10"},{"id":"p2222","type":"9"},{"id":"p2222","type":"9"},{"id":"p2222","type":"5"},{"id":"p2222","type":"11"},{"id":"p2222","type":"9"},{"id":"p2222","type":"8"},{"id":"p2222","type":"5"}],"p3333":[{"id":"p2222","type":"1"},{"id":"p2222","type":"2"},{"id":"p2222","type":"3"},{"id":"p2222","type":"3"},{"id":"p2222","type":"4"},{"id":"p2222","type":"4"},{"id":"p2222","type":"-1"},{"id":"p2222","type":"0"},{"id":"p2222","type":"-1"},{"id":"p2222","type":"0"},{"id":"p2222","type":"6"},{"id":"p2222","type":"6"},{"id":"p2222","type":"-1"},{"id":"p2222","type":"7"},{"id":"p2222","type":"7"},{"id":"p2222","type":"7"},{"id":"p2222","type":"-1"},{"id":"p2222","type":"8"},{"id":"p2222","type":"-1"},{"id":"p2222","type":"8"},{"id":"p2222","type":"10"},{"id":"p2222","type":"10"},{"id":"p2222","type":"10"},{"id":"p2222","type":"9"},{"id":"p2222","type":"9"},{"id":"p2222","type":"5"},{"id":"p2222","type":"11"},{"id":"p2222","type":"9"},{"id":"p2222","type":"8"},{"id":"p2222","type":"5"}]}}';
    //var positionJSON = positionjf + positionj1 + positionj2 + positionj3 + positionj4 + positionjl;


    //画出对应玩家棋盘上的所有棋子，并将其信息存入棋盘
    function draw(json, target) {
        //根据target确定用哪一个点位数组，放入哪一个div中
        var parray = positionArray[target];
        var darray = divArray[target];
        //通过eval函数来取出对应于玩家的点位数组
        var array = eval("json.position." + playerArray[playerDirectionArray[target]]);
        //循环数组中的前30个点位
        for (var x = 0; x < 30; x++) {
            //因为是画左边，进行了一次旋转，所以先要把坐标进行转换
            var i = eval(changeArray[target]);

            //将棋子的信息与最大的棋盘数组关联
            var m = eval(changeArray2[target][0]);
            var n = eval(changeArray2[target][1]);
            chessboardArray[m][n].chesspieces = new chesspieces(array[x].id, array[x].type);
            //根据是否有棋子改变棋盘格子的属性
            if (array[x].type != -1) {
                chessboardArray[m][n].haspieces = 1;
            }
            else {
                chessboardArray[m][n].haspieces = 0;
            }

            //如果type不等于-1，说明有棋子
            if (parseInt(array[x].type) != -1) {
                //如果是自己的棋子，就将具体名称画上
                if (array[x].id == playerArray[playerDirectionArray[0]]) {
                    var img1 = $("<img class='chess selfchess newchess' index='" + x + "' src='" + imgfile + "/" + chessArray[parseInt(array[x].type)] + directionArray[target] + ".png' style='top:" + parray[i][0] + "px;left:" + parray[i][1] + "px;'/>");
                    var img2 = $("<img class='chess selfchess newchess' src='" + imgfile + "/" + backArray[playerDirectionArray[0]] + directionArray[target] + ".png' style='top:" + parray[i][0] + "px;left:" + parray[i][1] + "px;'/>");
                    darray.append(img2);
                    darray.append(img1);
                }
                    //如果不是自己的棋子，就画一个背景色
                else {
                    //判断应该画哪一个背景色
                    var currentDraw = -1;
                    for (var j = 0; j < backArray.length; j++) {
                        if (playerArray[j] == array[x].id) {
                            currentDraw = j;
                            break;
                        }
                    }
                    var img3 = $("<img class='chess newchess' src='" + imgfile + "/" + backArray[currentDraw] + directionArray[target] + ".png' style='top:" + parray[i][0] + "px;left:" + parray[i][1] + "px;' />");
                    darray.append(img3);
                }
            }
        }
        //画中间的9个格子，只需要画一次
        if (target == 0) {
            for (var x = 30; x < 39; x++) {
                //将棋子的信息与最大的棋盘数组关联
                var m = eval(changeArray2[4][0]);
                var n = eval(changeArray2[4][1]);
                chessboardArray[m][n].chesspieces = new chesspieces(array[x].id, array[x].type);
                //根据是否有棋子改变棋盘格子的属性
                if (array[x].type != -1) {
                    chessboardArray[m][n].haspieces = 1;
                }
                else {
                    chessboardArray[m][n].haspieces = 0;
                }

                if (parseInt(array[x].type) != -1) {
                    if (array[x].id == playerArray[playerDirectionArray[0]]) {
                        var img1 = $("<img class='chess newchess' src='" + imgfile + "/" + chessArray[parseInt(array[x].type)] + directionArray[target] + ".png' style='top:" + centerPosition[x - 30][0] + "px;left:" + centerPosition[x - 30][1] + "px;'/>");
                        var img2 = $("<img class='chess newchess' src='" + imgfile + "/" + backArray[playerDirectionArray[0]] + directionArray[target] + ".png' style='top:" + centerPosition[x - 30][0] + "px;left:" + centerPosition[x - 30][1] + "px;'/>");
                        $("#center").append(img2);
                        $("#center").append(img1);
                    }
                        //如果不是自己的棋子，就画一个背景色
                    else {
                        //判断应该画哪一个背景色
                        var currentDraw = -1;
                        for (var j = 0; j < backArray.length; j++) {
                            if (playerArray[j] == array[x].id) {
                                currentDraw = j;
                                break;
                            }
                        }
                        var img3 = $("<img class='chess newchess' src='" + imgfile + "/" + backArray[currentDraw] + directionArray[target] + ".png' style='top:" + centerPosition[x - 30][0] + "px;left:" + centerPosition[x - 30][1] + "px;' />");
                        $("#center").append(img3);
                    }
                }
            }
        }
    }
    //画出测试棋盘的棋子类型
    for (var i = 0; i < 17; i++) {
        for (var j = 0; j < 17; j++) {
            if (chessboardArray[i][j].chesspieces != null) {
                $("#showtest2").append($("<div style='width:70px;height:70px;float:left;text-align:center;'>" + chessboardArray[i][j].chesspieces.player + " :" + chessboardArray[i][j].chesspieces.chesstype + " :" + chessboardArray[i][j].haspieces + "</div>"));
            }
            else {
                $("#showtest2").append($("<div style='width:70px;height:70px;float:left;text-align:center;'>00</div>"));
            }
        }
        $("#showtest2").append($("<div style='clear:both;'></div>"));
    }

    //判断当前用户的座位号，改变视角
    var value = $("#currentseat").text();
    switch (parseInt(value)) {
        case 0:
            {
                playerDirectionArray = new Array(0, 1, 2, 3);
                modifyDivSeat()
            } break;
        case 1:
            {
                playerDirectionArray = new Array(1, 2, 3, 0);
                modifyDivSeat()
            } break;
        case 2:
            {
                playerDirectionArray = new Array(2, 3, 0, 1);
                modifyDivSeat()
            } break;
        case 3:
            {
                playerDirectionArray = new Array(3, 0, 1, 2);
                modifyDivSeat()
            } break;
    }

    /////////////////////////////////////////////////具体的下棋部分

    //当前游戏所处的状态，0代表未准备，1代表已准备，2代表所有人都准备好，游戏开始
    var gameProgress = 0;
    //根据游戏状态改变div的点击事件

    //获取用户保存的初始点位
    var positionJSON = $("#currentposition").text();
    var chess = <%=currentPosition%>
    //画出棋子
    draw(chess, 0);
    //画出棋盘
    drawChessBoardDiv()
    //修改div和作为对应关系
    function modifyDivSeat() {
        for (var i = 0; i < playerDirectionArray.length; i++) {
            $("#player" + i).attr("seatid", playerDirectionArray[i]);
            $("#name" + i).attr("seatid", playerDirectionArray[i]);
        }
    }
    //画出已经准备好的玩家的棋子,target指的是座位号
    function drawReadyPlayer(target) {
        var divnum;
        //寻找和座位编号相对应的div位置
        for (var y = 0; y < playerDirectionArray.length; y++) {
            if (target == playerDirectionArray[y]) {
                divnum = y;
            }
        }
        for (var x = 0; x < 30; x++) {
            if (x != 6 && x != 8 && x != 12 && x != 16 && x != 18) {
                //根据target确定用哪一个点位数组，放入哪一个div中
                var parray = positionArray[divnum];
                var darray = divArray[divnum];
                var i = eval(changeArray[divnum]);
                var img3 = $("<img class='chess onlyback' player='" + playerArray[target] + "' src='" + imgfile + "/" + backArray[target] + directionArray[divnum] + ".png' style='top:" + parray[i][0] + "px;left:" + parray[i][1] + "px;' />");
                darray.append(img3);
            }
        }
    }


    ////////////////刷新用户头像 开始
    var oldplayer = "";
    var getPlayerInterval = setInterval(function () {
        $.get("GetPlayer.ashx", {}, function (re) {
            //如果玩家发生了改变
            if (oldplayer != re) {
                oldplayer = re;
                var playerjson = JSON.parse(re);
                //这里的i表示的是桌子的座位号，并不是自己看到的div相对应的位置
                for (var i = 0; i < playerjson.length; i++) {
                    //如果不是自己,并且玩家点了准备，就画出背景
                    if (playerDirectionArray[0] != i && playerjson[i].ready == 1) {
                        drawReadyPlayer(i);
                    }
                    //改变玩家数组
                    var tempplayer = playerArray[i];
                    playerArray[i] = playerjson[i].player;
                    //如果某个位置有玩家
                    if (playerjson[i].player != "") {
                        //这里必须把i作为参数传入，因为座位号在后面需要用到
                        //而这里是异步请求，不传的话直接获取只会得到 i=4
                        $.get("GetPlayerInfo.ashx", { "player": playerjson[i].player, "seat": i }, function (re1) {
                            var infojson = JSON.parse(re1);
                            $(".headimg").filter("[seatid=" + infojson.seat + "]").html("<img class='face' src='playerimg/" + infojson.img + "' />");
                            $(".nickname").filter("[seatid=" + infojson.seat + "]").text(infojson.nickname);
                        })
                    }
                    else {
                        //清空已经存在的头像昵称棋子
                        $(".headimg").filter("[seatid=" + i + "]").empty();
                        $(".nickname").filter("[seatid=" + i + "]").text("");
                        $(".onlyback").filter("[player=" + tempplayer + "]").remove();
                    }
                }
                //如果4个人都准备好了那就需要开始游戏
                if (playerjson[0].ready == 1 && playerjson[1].ready == 1 && playerjson[2].ready == 1 && playerjson[3].ready == 1) {

                    //清除所有的棋盘
                    $(".onlyback").remove();
                    $(".selfchess").remove();
                    //清除棋盘div的点击事件
                    ClearDivClick();
                    //设立新的计时器去获取所有玩家的点位，并且画出新的棋盘
                    beginInterval = setInterval(function () {
                        $.get("GetAllPosition.ashx", {}, function (re) {
                            if (totalposition != re) {
                                totalposition = re;
                                //重新绘制棋盘，这里是为了防止屏幕过分闪动
                                $(".newchess").addClass("oldchess");
                                $(".oldchess").removeClass("newchess");
                                //清除div点击事件
                                ClearDivClick();

                                //标记有没有输
                                var loseornot = true;
                                chess = JSON.parse(re);
                                //先去判断自己的军旗还在不在
                                var temparray = eval("chess.position." + $("#currentplayer").text());
                                if (temparray[26].type != 11 && temparray[28].type != 11) {
                                    eval("chess.seat" + $("#currentseat").text() + " = 1");
                                    //清除已经输掉的玩家的所有棋子
                                    clearLoserChess($("#currentplayer").text());
                                }
                                eval("if(chess.seat" + $("#currentseat").text() + " == 0) loseornot = false;");

                                //判断游戏是否结束了
                                if (chess.seat0 == 1 && chess.seat2 == 1 || chess.seat1 == 1 && chess.seat3 == 1) {
                                    if (alertornot == 1) {
                                        alert("游戏结束");
                                        alertornot = 0;
                                    }
                                    chess.identity = -2;
                                    sendNewPosition();
                                    resetAll();
                                    return;
                                }
                                for (var i = 0; i < 4; i++) {
                                    draw(chess, i);
                                }
                                //清除旧的棋子
                                setTimeout(function () { $(".oldchess").remove(); }, 100);
                                //如果轮到自己下棋
                                if (chess.identity == $("#currentseat").text()) {
                                    //如果军旗已经没了，输了
                                    if (loseornot) {
                                        sendNewPosition();
                                    }
                                    else {
                                        setTimeInterval();
                                        SetDivClickType1();
                                    }
                                }
                            }
                        });
                    }, 500);
                    //清除刷头像的计时器
                    clearInterval(getPlayerInterval);
                }
            }
        });
    }, 10);
    //用来控制只弹出一次游戏结束的信息
    var alertornot = 1;
    ////////////////刷新用户头像 结束

    //清除已经输掉的玩家的所有棋子
    function clearLoserChess(player) {
        //alert(player);
        //循环4个玩家的点位
        for (var i = 0; i < 4; i++) {
            var ttarray = eval("chess.position." + playerArray[playerDirectionArray[i]]);
            //循环39个棋子
            for (var j = 0; j < 39; j++) {
                //如果是输家的棋子
                if (ttarray[j].id == player) {
                    ttarray[j].type = -1;
                }
            }
        }
    }

    /////////////////设置时间计时器 开始
    var tInterval;
    var tOut;
    function setTimeInterval() {
        var temptime = 10;
        $("#timeinterval").text(temptime);
        tInterval = setInterval(function () {
            temptime -= 1;
            if (temptime < 0) {
                temptime = 0;
            }
            $("#timeinterval").text(temptime);
        }, 1000);
        tOut = setTimeout(function () {
            clearTimeInterval();
            sendNewPosition();
        }, 11000);
    }
    function clearTimeInterval() {
        $(".chessback").css("backgroundColor", "transparent");
        clearInterval(tInterval);
        clearTimeout(tOut);
        isChessLifted = null;
        $("#timeinterval").text("");
    }
    /////////////////设置时间计时器 结束

    //点击准备按钮
    $("#getready").click(function () {
        $(".chessback").removeClass("chosendiv");
        $.get("GetReady.ashx", { "seat": $("#currentseat").text() }, function () { });
        positionAlready();
    })
    $("#quit").click(function () {
        $.get("Quit.ashx", { "seat": $("#currentseat").text() }, function () { })
    })
    //将排好的点位放入数据库
    function positionAlready() {
        var charray = new Array();
        for (var i = 11; i <= 16; i++) {
            for (var j = 6; j <= 10; j++) {
                charray.push('{"id":"' + chessboardArray[i][j].chesspieces.player + '","type":"' + chessboardArray[i][j].chesspieces.chesstype + '"}');
            }
        }
        var temp = '[' + charray.join(",") + ',{"id":"p3333","type":"-1"},{"id":"p3333","type":"-1"},{"id":"p3333","type":"-1"},{"id":"p3333","type":"-1"},{"id":"p3333","type":"-1"},{"id":"p3333","type":"-1"},{"id":"p3333","type":"-1"},{"id":"p3333","type":"-1"},{"id":"p3333","type":"-1"}]';
        $.post("PositionAlready.ashx", { "player": $("#currentplayer").text(), "position": temp }, function () { });
    }
    //游戏开始后的计时器
    var beginInterval;
    //游戏开始后用来保存所有的position
    var totalposition;

    //原先的行数和列数
    var oldrow;
    var oldcol;
    //设置棋盘div被点击事件0
    //用于游戏开始之前用户自己的摆棋
    function SetDivClickType0() {
        $(".chessback").click(function () {
            var rule1 = true, rule2 = true; //分别是 拿起的棋子落下点的判断  落下点棋子换位的判断
            var clickChess = chessboardArray[$(this).attr("row")][$(this).attr("col")];
            var newrow = parseInt($(this).attr("row"));
            var newcol = parseInt($(this).attr("col"));
            //如果没有拿起过棋子
            if (isChessLifted == null) {
                //如果点击的是自己的棋子，那就拿起棋子
                if (clickChess.chesspieces.player == playerArray[playerDirectionArray[0]] && clickChess.haspieces == 1) {
                    //alert(clickChess.chesspieces.chesstype);
                    $(this).addClass("chosendiv");
                    isChessLifted = clickChess.chesspieces;
                    oldrow = $(this).attr("row");
                    oldcol = $(this).attr("col");
                }
            }
                //如果已经拿起了棋子
            else {
                //alert(oldrow + "  " + oldcol);
                //如果点击的是原先的棋子就放下棋子
                if (isChessLifted == clickChess.chesspieces) {
                    $(this).removeClass("chosendiv");
                    isChessLifted = null;
                    rule1 = false;
                }
                    //如果当前点击的是营
                else if (clickChess.type == 2) {
                    rule2 = false;
                    alert("不可以放在营中")
                }
                    //如果拿起的是军旗，就只能放在2个军旗室里
                else if (isChessLifted.chesstype == 11) {
                    if (clickChess.type != 5) {
                        rule1 = false;
                        alert("军旗必须放在军旗室");
                    }
                }
                    //如果拿起的是炸弹，不能放在第一排
                else if (isChessLifted.chesstype == 0) {
                    if (newrow == 11) {
                        rule1 = false;
                        alert("炸弹不能放在第一排");
                    }
                }
                    //如果拿起的是地雷，就只能放在后两排
                else if (isChessLifted.chesstype == 10) {
                    if (newrow < 15) {
                        rule1 = false;
                        alert("地雷只能放在最后两排");
                    }
                }
                    //如果放的位置超过了自己的棋盘范围
                else if (newrow < 11) {
                    rule1 = false;
                }


                //如果现在被点击的是军旗
                if (clickChess.chesspieces.chesstype == 11) {
                    if (oldrow != 16 || oldcol != 7 && oldcol != 9) {
                        rule2 = false;
                        alert("军旗必须放在军旗室");
                    }
                }
                    //如果现在被点击的是炸弹
                else if (clickChess.chesspieces.chesstype == 0) {
                    if (oldrow == 11) {
                        rule2 = false;
                        alert("炸弹不能放在第一排");
                    }
                }
                else if (clickChess.chesspieces.chesstype == 10) {
                    if (oldrow < 15) {
                        rule1 = false;
                        alert("地雷只能放在最后两排");
                    }
                }

                //如果2个判断都是true，那就说明可以交换
                if (rule1 && rule2) {
                    changeTwoChess(clickChess, newrow, newcol);
                }
            }
        });
    }
    //将换2个棋子位置所需要做的事情
    //clickChess 现在点击的棋子
    function changeTwoChess(clickChess, newrow, newcol) {
        var player = clickChess.chesspieces.player
        var type = clickChess.chesspieces.chesstype;
        //原先的点位变成现在点击的棋子
        chessboardArray[oldrow][oldcol].chesspieces = new chesspieces(player, type);
        //修改原先点位的图片
        $(".selfchess").filter("[index='" + ((oldrow - 11) * 5 + (oldcol - 6)) + "']").attr("src", imgfile + "/" + chessArray[parseInt(clickChess.chesspieces.chesstype)] + ".png");
        //取消div的边框
        $(".chessback").removeClass("chosendiv");
        //现在点击的棋子变成拿起的棋子
        clickChess.chesspieces = new chesspieces(isChessLifted.player, isChessLifted.chesstype);
        //修改现在点位的图片
        $(".selfchess").filter("[index='" + ((newrow - 11) * 5 + (newcol - 6)) + "']").attr("src", imgfile + "/" + chessArray[parseInt(isChessLifted.chesstype)] + ".png");
        //放下棋子
        isChessLifted = null;
    }

    //设置棋盘div被点击事件1
    //用于游戏开始之后的下棋
    function SetDivClickType1() {
        $(".chessback").click(function () {
            var row = parseInt($(this).attr("row"));
            var col = parseInt($(this).attr("col"));
            var cb = chessboardArray[row][col];
            //如果还没有拿起过棋子
            if (isChessLifted == null) {
                //alert(cb.chesspieces.chesstype + "  " + cb.chesspieces.player);
                //如果 不是军旗营 格子上有棋子 是自己的棋子 不是地雷
                if (cb.type != 5 && cb.haspieces == 1 && cb.chesspieces.player == playerArray[playerDirectionArray[0]] && cb.chesspieces.chesstype != 10) {
                    //拿起一枚棋子
                    isChessLifted = cb.chesspieces;
                    cb.checkmethod(row, col);
                    //记录下旧的点位
                    oldrow = $(this).attr("row");
                    oldcol = $(this).attr("col");
                }
            }
                //如果已经拿起过棋子了
            else {
                //如果点的还是自己的棋子
                if (cb.chesspieces.player == playerArray[playerDirectionArray[0]] && cb.chesspieces.chesstype != -1 && cb.chesspieces.chesstype != 10 && cb.type != 5) {
                    //换一枚棋子
                    isChessLifted = cb.chesspieces;
                    cb.checkmethod(row, col);
                    //改变旧的点位
                    oldrow = $(this).attr("row");
                    oldcol = $(this).attr("col");
                }
                    //如果不是自己的棋子，就去判断是不是在effectiveArray中
                else {
                    var flag = 0;
                    for (var i = 0; i < effectiveArray.length; i++) {
                        if (row == effectiveArray[i][0] && col == effectiveArray[i][1]) {
                            flag = 1;
                        }
                    }
                    if (flag == 1) {
                        $(".chessback").css("backgroundColor", "transparent");
                        //移除旧点位的棋子
                        chessboardArray[oldrow][oldcol].haspieces = 0;
                        chessboardArray[oldrow][oldcol].chesspieces = new chesspieces("p0000", -1);
                        //如果没有棋子
                        if (cb.haspieces == 0) {
                            //新点位添加棋子
                            chessboardArray[row][col].haspieces = 1;
                            chessboardArray[row][col].chesspieces = new chesspieces(isChessLifted.player, isChessLifted.chesstype);
                            //放下棋子
                            isChessLifted = null;
                        }
                            //如果有敌方棋子
                        else {
                            //0同归于尽，1吃掉，2被吃掉
                            var type = -1;
                            //如果被吃的是军旗，那就要找到玩家对应的座位号，标记为输
                            if (cb.chesspieces.chesstype == 11) {
                                type = 1;
                            }
                                //如果自己的是炸弹，或者对面的是炸弹，那总是同归于尽
                            else if (isChessLifted.chesstype == 0 || cb.chesspieces.chesstype == 0) {
                                type = 0;
                            }
                                //如果自己的不是工兵，对面的是地雷
                            else if (isChessLifted.chesstype != 9 && cb.chesspieces.chesstype == 10) {
                                type = 2;
                            }
                                //如果自己的是工兵，对面是地雷
                            else if (isChessLifted.chesstype == 9 && cb.chesspieces.chesstype == 10) {
                                type = 1;
                            }
                                //如果自己的棋子下标大于对面的棋子，意味着会被对面吃掉
                            else if (cb.chesspieces.chesstype < isChessLifted.chesstype) {
                                type = 2;
                            }
                                //如果两个棋子相等
                            else if (cb.chesspieces.chesstype == isChessLifted.chesstype) {
                                type = 0;
                            }
                                //如果能吃掉对方的棋子
                            else {
                                type = 1;
                            }
                            if (type == 0) {
                                //移除对方的棋子
                                chessboardArray[row][col].haspieces = 0;
                                chessboardArray[row][col].chesspieces = new chesspieces("p0000", -1);
                            }
                            else if (type == 1) {
                                //新点位添加棋子
                                chessboardArray[row][col].haspieces = 1;
                                chessboardArray[row][col].chesspieces = new chesspieces(isChessLifted.player, isChessLifted.chesstype);
                            }
                            isChessLifted = null;
                        }
                        //更新点位数据
                        updatePosition()
                        sendNewPosition();
                        //清除时间计时器
                        clearTimeInterval();
                    }
                }
            }
        });
    }

    //更新点位数据
    function updatePosition() {
        for (var i = 0; i < 30; i++) {
            //更新自己的点位
            eval("chess.position." + playerArray[playerDirectionArray[0]] + "[i].id = chessboardArray[parseInt(i / 5) + 11][i % 5 + 6].chesspieces.player");
            eval("chess.position." + playerArray[playerDirectionArray[0]] + "[i].type = chessboardArray[parseInt(i / 5) + 11][i % 5 + 6].chesspieces.chesstype");
            //更新左边的点位
            eval("chess.position." + playerArray[playerDirectionArray[1]] + "[i].id = chessboardArray[i % 5 + 6][5 - parseInt(i / 5)].chesspieces.player");
            eval("chess.position." + playerArray[playerDirectionArray[1]] + "[i].type = chessboardArray[i % 5 + 6][5 - parseInt(i / 5)].chesspieces.chesstype");
            //更新对面的点位
            eval("chess.position." + playerArray[playerDirectionArray[2]] + "[i].id = chessboardArray[parseInt((29 - i) / 5)][(29 - i) % 5 + 6].chesspieces.player");
            eval("chess.position." + playerArray[playerDirectionArray[2]] + "[i].type = chessboardArray[parseInt((29 - i) / 5)][(29 - i) % 5 + 6].chesspieces.chesstype");
            //更新右面的点位
            eval("chess.position." + playerArray[playerDirectionArray[3]] + "[i].id = chessboardArray[4 - i % 5 + 6][parseInt(i / 5) + 11].chesspieces.player");
            eval("chess.position." + playerArray[playerDirectionArray[3]] + "[i].type = chessboardArray[4 - i % 5 + 6][parseInt(i / 5) + 11].chesspieces.chesstype");
        }
        for (var x = 30; x < 39; x++) {
            //更新自己的点位
            eval("chess.position." + playerArray[playerDirectionArray[0]] + "[x].id = chessboardArray[parseInt((x - 30) / 3) * 2 + 6][(x - 30) % 3 * 2 + 6].chesspieces.player");
            eval("chess.position." + playerArray[playerDirectionArray[0]] + "[x].type = chessboardArray[parseInt((x - 30) / 3) * 2 + 6][(x - 30) % 3 * 2 + 6].chesspieces.chesstype");
            //更新左边的点位
            eval("chess.position." + playerArray[playerDirectionArray[1]] + "[x].id = chessboardArray[(x - 30) % 3 * 2 + 6][4 - parseInt((x - 30) / 3) * 2 + 6].chesspieces.player");
            eval("chess.position." + playerArray[playerDirectionArray[1]] + "[x].type = chessboardArray[(x - 30) % 3 * 2 + 6][4 - parseInt((x - 30) / 3) * 2 + 6].chesspieces.chesstype");
            //更新对面的点位
            eval("chess.position." + playerArray[playerDirectionArray[2]] + "[x].id = chessboardArray[4 - parseInt((x - 30) / 3) * 2 + 6][4 - (x - 30) % 3 * 2 + 6].chesspieces.player");
            eval("chess.position." + playerArray[playerDirectionArray[2]] + "[x].type = chessboardArray[4 - parseInt((x - 30) / 3) * 2 + 6][4 - (x - 30) % 3 * 2 + 6].chesspieces.chesstype");
            //更新右边的点位
            eval("chess.position." + playerArray[playerDirectionArray[3]] + "[x].id = chessboardArray[4 - (x - 30) % 3 * 2 + 6][parseInt((x - 30) / 3) * 2 + 6].chesspieces.player");
            eval("chess.position." + playerArray[playerDirectionArray[3]] + "[x].type = chessboardArray[4 - (x - 30) % 3 * 2 + 6][parseInt((x - 30) / 3) * 2 + 6].chesspieces.chesstype");
        }

    }
    //发送新的坐标，以及改变走棋的玩家座位号
    function sendNewPosition() {
        chess.identity += 1;
        if (chess.identity == 4) {
            chess.identity = 0;
        }
        var newjsonposition = JSON.stringify(chess);
        $.post("UpdateNewPosition.ashx", { "position": newjsonposition }, function () { })
    }
    //重置所有界面
    function resetAll() {
        clearInterval(beginInterval);
        $.get("ReSetAll.ashx", {}, function () { });
        setTimeout(function () { location.reload(); }, 5000);
    }

    //移出div的被点击事件
    function ClearDivClick() {
        $(".chessback").unbind("click");
    }
</script>
</html>

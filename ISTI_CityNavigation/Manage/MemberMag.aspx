<%@ Page Title="" Language="C#" MasterPageFile="~/Manage/BackEnd.Master" AutoEventWireup="true" CodeBehind="MemberMag.aspx.cs" Inherits="ISTI_CityNavigation.Manage.MemberMag" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            //分頁設定
            Page.Option.SortMethod = "+";
            Page.Option.SortName = "M_Name";
            getData(0);
            
            getddl("03", "#SearchComp");
            getddl("03", "#mComp");

            /// 表頭排序
            $(document).on("click", "a[name='sortbtn']", function () {
                $("a[name='sortbtn']").removeClass("asc desc")
                if (Page.Option.SortName != $(this).attr("sortname")) {
                    Page.Option.SortMethod = "-";
                }
                Page.Option.SortName = $(this).attr("sortname");
                if (Page.Option.SortMethod == "-") {
                    Page.Option.SortMethod = "+";
                    $(this).addClass('asc');
                }
                else {
                    Page.Option.SortMethod = "-";
                    $(this).addClass('desc');
                }
                getData(0);
            });

            /// 新增
            $(document).on("click","#newbtn",function () {
                doShowDialog("新增會員");
            });

            /// 修改
            $(document).on("click","input[name='modbtn']",function () {
                $.ajax({
                    type: "POST",
                    async: false, //在沒有返回值之前,不會執行下一步動作
                    url: "mHandler/GetMemberInfo.aspx",
                    data: {
                        id: $(this).attr("aid"),
                    },
                    error: function (xhr) {
                        alert(xhr.responseText);
                    },
                    success: function (data) {
                        if ($(data).find("Error").length > 0) {
                            alert($(data).find("Error").attr("Message"));
                        }
                        else {
                            $(data).find("data_item").each(function (i) {
                                $("#tmpid").val($(this).children("M_ID").text().trim());
                                $("#tmpgid").val($(this).children("M_Guid").text().trim());
                                $("#mAcc").val($(this).children("M_Account").text().trim());
                                $("#tmpacc").val($(this).children("M_Account").text().trim());
                                $("#mPwd").val($(this).children("M_Pwd").text().trim());
                                $("#tmppw").val($(this).children("M_Pwd").text().trim());
                                $("#mName").val($(this).children("M_Name").text().trim());
                                $("#mEmail").val($(this).children("M_Email").text().trim());
                                $("#tmpmail").val($(this).children("M_Email").text().trim());
                                $("#mComp").val($(this).children("M_Competence").text().trim());
                            });
                            doShowDialog("編輯會員");
                        }
                    }
                });
            });

            /// 取消
            $(document).on("click", "#cancelbtn", function () {
                if (confirm("確定取消?"))
                    $("#NewBlock").dialog("close");
            });

            /// 儲存
            $(document).on("click", "#savebtn", function () {
                if (Verification() != "") {
                    alert(Verification());
                    return;
                }

                $.ajax({
                    type: "POST",
                    async: false, //在沒有返回值之前,不會執行下一步動作
                    url: "mHandler/addMember.aspx",
                    data: {
                        id: $("#tmpid").val(),
                        gid: $("#tmpgid").val(),
                        M_Name: $("#mName").val(),
                        M_Account: $("#mAcc").val(),
                        oldacc: $("#tmpacc").val(),
                        M_Pwd: $("#mPwd").val(),
                        oldpw: $("#tmppw").val(),
                        M_Email: $("#mEmail").val(),
                        oldmail: $("#tmpmail").val(),
                        M_Competence: $("#mComp").val()
                    },
                    error: function (xhr) {
                        alert(xhr.responseText);
                    },
                    success: function (data) {
                        if ($(data).find("Error").length > 0) {
                            alert($(data).find("Error").attr("Message"));
                        }
                        else {
                            alert($("Response", data).text());
                            getData(0);
                            $("#NewBlock").dialog("close");
                        }
                    }
                });
            });

            /// 刪除
            $(document).on("click", "input[name='delbtn']", function () {
                if (confirm('確定刪除?')) {
                    $.ajax({
                        type: "POST",
                        async: false, //在沒有返回值之前,不會執行下一步動作
                        url: "mHandler/DeleteMember.aspx",
                        data: {
                            id: $(this).attr("aid"),
                        },
                        error: function (xhr) {
                            alert(xhr.responseText);
                        },
                        success: function (data) {
                            if ($(data).find("Error").length > 0) {
                                alert($(data).find("Error").attr("Message"));
                            }
                            else {
                                alert($("Response", data).text());
                                getData(0);
                            }
                        }
                    });
                }
            });
        });// end js

        function getData(p) {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "mHandler/GetMemberList.aspx",
                data: {
                    SearchComp: $("#SearchComp").val(),
                    SearchStr: $("#SearchStr").val(),
                    PageNo: p,
                    PageSize: Page.Option.PageSize,
                    SortName: Page.Option.SortName,
                    SortMethod: Page.Option.SortMethod
                },
                error: function (xhr) {
                    alert(xhr.responseText);
                },
                success: function (data) {
                    if ($(data).find("Error").length > 0) {
                        alert($(data).find("Error").attr("Message"));
                    }
                    else {
                        $("#tablist tbody").empty();
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += '<tr>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("itemNo").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("M_Name").text().trim() + '</td>';
                                tabstr += '<td align="left" nowrap="nowrap">' + $(this).children("M_Email").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $.datepicker.formatDate('yy/mm/dd', new Date($(this).children("M_CreateDate").text().trim())) + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Competence").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">';
                                tabstr += '<input class="genbtn" type="button" name="modbtn" value="修改" aid="' + $(this).children("M_ID").text().trim() + '">&nbsp;';
                                tabstr += '<input class="genbtn" type="button" name="delbtn" value="刪除" aid="' + $(this).children("M_ID").text().trim() + '">';
                                tabstr += '</td></tr>';
                            });
                        }
                        else
                            tabstr += '<tr><td colspan="6">查詢無資料</td></tr>';
                        $("#tablist tbody").append(tabstr);
                        Page.Option.Selector = "#pageblock";
                        Page.CreatePage(p, $("total", data).text());
                    }
                }
            });
        }

         /// open dialog
        function doShowDialog(t_str) {
            /// dialog setting
            $("#NewBlock").dialog({
                title: t_str,
                autoOpen: false,
                width: 600,
                height: 250,
                closeOnEscape: true,
                position: { my: "center", at: "center", of: window },
                modal: true,
                resizable: false,
                close: function (event, ui) {
                    $(".dialogInput").val("");
                }
            });

            $("#NewBlock").dialog("open");
            event.preventDefault();
        }

         function getddl(gno, tagName) {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "mHandler/GetDDL.aspx",
                data: {
                    Group: gno
                },
                error: function (xhr) {
                    alert(xhr.responseText);
                },
                success: function (data) {
                    if ($(data).find("Error").length > 0) {
                        alert($(data).find("Error").attr("Message"));
                    }
                    else {
                        var ddlstr = '<option value="">請選擇</option>';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                ddlstr += '<option value="' + $(this).attr("C_Item") + '">' + $(this).attr("C_Item_cn") + '</option>';
                            });
                            $(tagName).empty();
                            $(tagName).append(ddlstr);
                        }
                    }
                }
            });
        }

        function Verification() {
            var msg = "";
            if ($("#mName").val() == "")
                msg += "請輸入【姓名】\n";
            if ($("#mAcc").val() == "")
                msg += "請輸入【帳號】\n";
            if ($("#mPwd").val() == "")
                msg += "請輸入【密碼】\n";
            if ($("#mEmail").val() == "")
                msg += "請輸入【E-Mail】\n";
            if ($("#mEmail").val().trim() != "") {
                var pattern = new RegExp(/^[+a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/i);
                if (!pattern.test($("#mEmail").val()))
                    msg += "請輸入正確Email\n";
            }
            if ($("#mComp").val() == "")
                msg += "請選擇【所屬單位/權限】\n";
            return msg;
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <input type="hidden" id="tmpid" class="dialogInput" />
    <input type="hidden" id="tmpgid" class="dialogInput" />
    <input type="hidden" id="tmppw" class="dialogInput" />
    <input type="hidden" id="tmpacc" class="dialogInput" />
    <input type="hidden" id="tmpmail" class="dialogInput" />
    <div class="twocol titleLineA">
        <div class="left"><span class="font-size4">會員管理</span></div><!-- left -->
        <div class="right">後臺管理 / 會員管理</div><!-- right -->
    </div><!-- twocol -->

    <div class="margin10T">
        所屬單位/權限：<select id="SearchComp"class="inputex"></select>&nbsp;&nbsp;
        關鍵字：<input id="SearchStr" type="test" class="inputex width30" />&nbsp;&nbsp;
        <input id="SearchBtn" type="button" value="查詢" class="genbtn" onclick="getData(0)" />
    </div>
    <div class="twocol margin10TB">
        <div class="right"><input id="newbtn" type="button" value="新增" class="genbtn" /></div>
    </div><!-- twocol -->

    <div class="stripeMeCS margin10T font-normal">
        <table id="tablist" width="100%" border="1" cellspacing="0" cellpadding="0">
            <thead>
                <tr>
                    <th nowrap="nowrap" style="width:40px;">項次</th>
                    <th nowrap="nowrap"><a href="javascript:void(0);" name="sortbtn" sortname="M_Name">姓名</a></th>
                    <th nowrap="nowrap"><a href="javascript:void(0);" name="sortbtn" sortname="M_Email">E-Mail</a></th>
                    <th nowrap="nowrap"><a href="javascript:void(0);" name="sortbtn" sortname="M_CreateDate">建立日期</th>
                    <th nowrap="nowrap"><a href="javascript:void(0);" name="sortbtn" sortname="M_Competence">所屬單位/權限</a></th>
                    <th nowrap="nowrap" style="width:150px;">動作</th>
                </tr>
            </thead>
            <tbody></tbody>
        </table>
        <div id="pageblock" class="margin20T textcenter"></div>
    </div>

    <div id="NewBlock" class="gentable" style="display:none; text-align:center;">
            <table style="border:none; width:100%;" cellspacing="0" cellpadding="0">
                <tr>
                    <th>姓名</th>
                    <td colspan="3"><input id="mName"  type="text" class="inputex width100 dialogInput" /></td>
                </tr>
                <tr>
                    <th>帳號</th>
                    <td><input id="mAcc"  type="text" class="inputex width100 dialogInput" /></td>
                    <th>密碼</th>
                    <td><input id="mPwd"  type="password" class="inputex width100 dialogInput" /></td>
                </tr>
                <tr>
                    <th>E-Mail</th>
                    <td colspan="3" align="left"><input id="mEmail"  type="text" class="inputex width100 dialogInput" /></td>
                </tr>
                <tr>
                    <th>所屬單位/權限</th>
                    <td colspan="3" align="left"><select id="mComp" class="inputex dialogInput"></select></td>
                </tr>
            </table>
            <div style="text-align:right; margin-top:5px;">
                <input type="button" class="genbtn" id="savebtn" value="儲存" />
                <input type="button" class="genbtn" id="cancelbtn" value="取消" />
            </div>
    </div>
</asp:Content>

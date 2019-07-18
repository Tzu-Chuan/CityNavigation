<%@ Page Title="" Language="C#" MasterPageFile="~/Manage/BackEnd.Master" AutoEventWireup="true" CodeBehind="IDB_DataLog.aspx.cs" Inherits="ISTI_CityNavigation.Manage.IDB_DataLog" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            //分頁設定
            Page.Option.SortMethod = "-";
            Page.Option.SortName = "IDL_ModDate";
            getData(0);

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
        });// end js

        function getData(p) {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "mHandler/GetIDB_DataLogList.aspx",
                data: {
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
                                tabstr += '<td align="left">' + $(this).children("IDL_Description").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("IDL_IP").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("IDL_ModName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $.datepicker.formatDate('yy/mm/dd', new Date($(this).children("IDL_ModDate").text().trim())) + '</td>';
                                tabstr += '</tr>';
                            });
                        }
                        else
                            tabstr += '<tr><td colspan="5">查詢無資料</td></tr>';
                        $("#tablist tbody").append(tabstr);
                        Page.Option.Selector = "#pageblock";
                        Page.CreatePage(p, $("total", data).text());
                    }
                }
            });
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="twocol titleLineA">
        <div class="left"><span class="font-size4">IDB 資料管理紀錄</span></div><!-- left -->
        <div class="right">後臺管理 / 系統修改紀錄 / IDB 資料管理紀錄</div><!-- right -->
    </div><!-- twocol -->

    <div class="stripeMeCS margin10TB font-normal">
        <table id="tablist" width="100%" border="1" cellspacing="0" cellpadding="0">
            <thead>
                <tr>
                    <th nowrap="nowrap" style="width:40px;">項次</th>
                    <th nowrap="nowrap"><a href="javascript:void(0);" name="sortbtn" sortname="IDL_Description">事件</a></th>
                    <th nowrap="nowrap" style="width:10%;"><a href="javascript:void(0);" name="sortbtn" sortname="IDL_IP">IP</a></th>
                    <th nowrap="nowrap"><a href="javascript:void(0);" name="sortbtn" sortname="IDL_ModName">異動者</th>
                    <th nowrap="nowrap" style="width:10%;"><a href="javascript:void(0);" name="sortbtn" sortname="IDL_ModDate">異動日期</a></th>
                </tr>
            </thead>
            <tbody></tbody>
        </table>
        <div id="pageblock" class="margin20T textcenter"></div>
    </div>
</asp:Content>

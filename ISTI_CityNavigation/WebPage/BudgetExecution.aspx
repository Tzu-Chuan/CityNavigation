<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="BudgetExecution.aspx.cs" Inherits="ISTI_CityNavigation.WebPage.BudgetExecution" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            getData();
        });

        function getData() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetBudgetExecution.aspx",
                data: {
                    Token: $("#InfoToken").val()
                },
                error: function (xhr) {
                    alert(xhr.responseText);
                },
                success: function (data) {
                    if ($(data).find("Error").length > 0) {
                        alert($(data).find("Error").attr("Message"));
                    }
                    else {
                        var strhead = '';
                        var strbody = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                if (i == 0) {
                                    strhead += '<thead><tr>';
                                    strhead += '<th colspan="2"></th>';
                                    strhead += '<th nowrap="nowrap" width="200">' + $(this).children("Str1").text().trim() + '年度</th>';
                                    strhead += '<th nowrap="nowrap" width="200">' + $(this).children("Str2").text().trim() + '年度</th>';
                                    strhead += '<th nowrap="nowrap" width="200">' + $(this).children("Str3").text().trim() + '年度</th></tr></thead>';
                                }
                                else {
                                    strbody += '<tr>';
                                    if (i == 1)
                                        strbody += '<th rowspan="2" width="150">年度預算</th><th width="150">委辦款</th>';
                                    else if (i == 2)
                                        strbody += '<th>補助款</th>';
                                    else if (i == 3)
                                        strbody += '<th rowspan="3">補助款</th><th align="left">(1) 中企處</th>';
                                    else if (i == 4)
                                        strbody += '<th align="left">(2) AI競賽獎助金/創業歸故里</th>';
                                    else if (i == 5)
                                        strbody += '<th align="left">(3) 148案補助支用(權責數)</th>';
                                    else if (i == 6)
                                        strbody += '<th colspan="2">預算剩餘</th>';
                                    else if (i == 7)
                                        strbody += '<th colspan="2">動支率</th>';

                                    if (i != ($(data).find("data_item").length - 1)) {
                                        strbody += '<td nowrap="nowrap" align="right">' + $.FormatThousandGroup(Number($(this).children("Str1").text().trim()).toFixed(0)) + '</td>';
                                        strbody += '<td nowrap="nowrap" align="right">' + $.FormatThousandGroup(Number($(this).children("Str2").text().trim()).toFixed(0)) + '</td>';
                                        strbody += '<td nowrap="nowrap" align="right">' + $.FormatThousandGroup(Number($(this).children("Str3").text().trim()).toFixed(0)) + '</td>';
                                    }
                                    else {
                                        strbody += '<td nowrap="nowrap" align="right">' + (parseFloat($(this).children("Str1").text().trim()) * 100).toFixed(2) + '%</td>';
                                        strbody += '<td nowrap="nowrap" align="right"></td>';
                                        strbody += '<td nowrap="nowrap" align="right"></td>';
                                    }
                                    strbody += '</tr>';
                                }
                            });
                            $("#tablist").empty();
                            $("#tablist").append(strhead + "<tbody>" + strbody + "</tbody>");
                            // 固定表頭
                            // left : 左側兩欄固定(需為th)
                            $(".hugetable table").tableHeadFixer({ "left": 2 });
                        }
                        else
                            $("#TabDiv").html("<span style='font-size:14pt; color:red;'>查詢無資料</span>");
                    }
                }
            });
        }
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="twocol titleLineA">
        <div class="left"><span class="font-size4">經費總表</span></div><!-- left -->
        <div class="right"><a href="CityInfo.aspx?city=02">首頁</a> / 智慧城鄉計畫提案 / 經費總表</div><!-- right -->
    </div><!-- twocol -->

    <div class="tabmenublockV2wrapper margin10T">
        <div class="tabmenublockV2 font-size3">
            <!--#include file="MoneyLink.html"-->
        </div><!-- tabmenublock -->
    </div><!-- tabmenublockV2wrapper -->

    <div id="TabDiv" class="stripeMeCS hugetable maxHeightD scrollbar-outer font-normal margin20T margin10B">
        <table id="tablist" border="0" cellspacing="0" cellpadding="0" width="100%"></table>
    </div>
</asp:Content>

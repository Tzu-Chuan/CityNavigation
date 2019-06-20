<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="CitySubsidyAnalyze.aspx.cs" Inherits="ISTI_CityNavigation.WebPage.CitySubsidyAnalyze" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            getData();
        });

        function getData() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetCitySubMoney.aspx",
                error: function (xhr) {
                    alert(xhr.responseText);
                },
                success: function (data) {
                    if ($(data).find("Error").length > 0) {
                        alert($(data).find("Error").attr("Message"));
                    }
                    else {
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                if (i != $(data).find("data_item").length - 1) {
                                    tabstr += '<tr>';
                                    tabstr += '<th nowrap>' + $(this).children("C_City").text().trim() + '</th>';
                                    tabstr += '<td nowrap align="center">' + FormatNumber($(this).children("C_PlanCount_NotAll").text().trim()) + '</td>';
                                    tabstr += '<td nowrap align="right">' + FormatNumber(Number($(this).children("C_SubMoney_NotAll").text().trim()).toFixed(0)) + '</td>';
                                    tabstr += '<td nowrap align="right">' + FormatNumber(Number($(this).children("C_PlanMoney_NotAll").text().trim()).toFixed(0)) + '</td>';
                                    tabstr += '<td nowrap align="right">' + FormatNumber(Number($(this).children("C_AssignSubMoney").text().trim()).toFixed(0)) + '</td>';
                                    tabstr += '<td nowrap align="right">' + FormatNumber(Number($(this).children("C_AssignTotalMoney").text().trim()).toFixed(0)) + '</td>';
                                    tabstr += '<td nowrap align="center">' + (parseFloat($(this).children("C_CitySubMoneyRatio_NotAll").text().trim()) * 100).toFixed(1) + '%</td>';
                                    tabstr += '<td nowrap align="center">' + (parseFloat($(this).children("C_CityTotalMoneyRatio_NotAll").text().trim()) * 100).toFixed(1) + '%</td>';
                                    tabstr += '<td nowrap align="center">' + FormatNumber($(this).children("C_PlanCount").text().trim()) + '</td>';
                                    tabstr += '<td nowrap align="right">' + FormatNumber(Number($(this).children("C_SubMoney").text().trim()).toFixed(0)) + '</td>';
                                    tabstr += '<td nowrap align="right">' + FormatNumber(Number($(this).children("C_PlanMoney").text().trim()).toFixed(0)) + '</td>';
                                    tabstr += '<td nowrap align="center">' + (parseFloat($(this).children("C_CitySubMoneyRatio").text().trim()) * 100).toFixed(1) + '%</td>';
                                    tabstr += '<td nowrap align="center">' + (parseFloat($(this).children("C_CityTotalMoneyRatio").text().trim()) * 100).toFixed(1) + '%</td>';
                                    tabstr += '</tr>';
                                }
                                // 合計
                                else {
                                    tabstr += '<tr class="spe">';
                                    tabstr += '<td nowrap align="center">' + $(this).children("C_City").text().trim() + '</td>';
                                    tabstr += '<td nowrap align="center">' + FormatNumber($(this).children("C_PlanCount_NotAll").text().trim()) + '</td>';
                                    tabstr += '<td nowrap align="right">' + FormatNumber(Number($(this).children("C_SubMoney_NotAll").text().trim()).toFixed(0)) + '</td>';
                                    tabstr += '<td nowrap align="right">' + FormatNumber(Number($(this).children("C_PlanMoney_NotAll").text().trim()).toFixed(0)) + '</td>';
                                    tabstr += '<td nowrap align="right">' + FormatNumber(Number($(this).children("C_AssignSubMoney").text().trim()).toFixed(0)) + '</td>';
                                    tabstr += '<td nowrap align="right">' + FormatNumber(Number($(this).children("C_AssignTotalMoney").text().trim()).toFixed(0)) + '</td>';
                                    tabstr += '<td nowrap align="center">' + (parseFloat($(this).children("C_CitySubMoneyRatio_NotAll").text().trim()) * 100).toFixed(0) + '%</td>';
                                    tabstr += '<td nowrap align="center">' + (parseFloat($(this).children("C_CityTotalMoneyRatio_NotAll").text().trim()) * 100).toFixed(0) + '%</td>';
                                    tabstr += '<td nowrap align="center">' + FormatNumber($(this).children("C_PlanCount").text().trim()) + '</td>';
                                    tabstr += '<td nowrap align="right">' + FormatNumber(Number($(this).children("C_SubMoney").text().trim()).toFixed(0)) + '</td>';
                                    tabstr += '<td nowrap align="right">' + FormatNumber(Number($(this).children("C_PlanMoney").text().trim()).toFixed(0)) + '</td>';
                                    tabstr += '<td nowrap align="center">' + (parseFloat($(this).children("C_CitySubMoneyRatio").text().trim()) * 100).toFixed(0) + '%</td>';
                                    tabstr += '<td nowrap align="center">' + (parseFloat($(this).children("C_CityTotalMoneyRatio").text().trim()) * 100).toFixed(0) + '%</td>';
                                    tabstr += '</tr>';
                                }
                            });
                            $("#tablist tbody").empty();
                            $("#tablist tbody").append(tabstr);
                            // 固定表頭
                            // left : 左側兩欄固定(需為th)
                            $(".hugetable table").tableHeadFixer({ "left": 1 });
                        }
                        else
                            $("#TabDiv").html("<span style='font-size:14pt; color:red;'>查詢無資料</span>");
                    }
                }
            });
        }

        // 千分位
        function FormatNumber(n) {
            n = Number(n); // 去小數點為0
            n += ""; // 轉字串
            var arr = n.split(".");
            var re = /(\d{1,3})(?=(\d{3})+$)/g;
            return arr[0].replace(re, "$1,") + (arr.length == 2 ? "." + arr[1] : "");
        }
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="twocol titleLineA">
        <div class="left"><span class="font-size4">經費總表</span></div><!-- left -->
        <div class="right">首頁 / 智慧城鄉計畫提案 / 經費總表</div><!-- right -->
    </div><!-- twocol -->

    <div class="tabmenublockV2wrapper margin10T">
        <div class="tabmenublockV2 font-size3">
            <span class="SlimTabBtnV2"><a href="BudgetExecution.aspx" target="_self">智慧城鄉生活應用發展計畫_107-109年預計經費執行情形(本局18億)</a></span>
            <span class="SlimTabBtnV2 SlimTabBtnV2Current"><a>補助經費縣市分析</a></span>
            <span class="SlimTabBtnV2"><a href="SubsidyServiceAnalyze.aspx" target="_self">補助經費服務主軸分析</a></span>
            <span class="SlimTabBtnV2"><a href="SubsidyCategoryAnalyze.aspx" target="_self">補助經費計畫類別分析</a></span>
        </div><!-- tabmenublock -->
    </div><!-- tabmenublockV2wrapper -->

    <div id="TabDiv" class="stripeMeCS hugetable maxHeightD scrollbar-outer font-normal margin20T margin10B">
        <table id="tablist" border="0" cellspacing="0" cellpadding="0" width="100%">
            <thead>
                <tr>
                    <th nowrap>縣市別</th>
                    <th nowrap>不含全區<br>計畫數</th>
                    <th nowrap>不含全區<br>補助款合計<br>(千元)</th>
                    <th nowrap>不含全區<br>計畫總經費合計<br>(千元)</th>
                    <th nowrap>17案全區<br>分配補助款<br>(千元)</th>
                    <th nowrap>17案全區<br>分配總經費<br>(千元)</th>
                    <th nowrap>不含全區<br>縣市補助經費<br>佔總補助經費比例</th>
                    <th nowrap>不含全區<br>縣市總經費<br>佔總經費比例</th>
                    <th nowrap>含全區<br>計畫件數</th>
                    <th nowrap>補助款合計<br>(千元)</th>
                    <th nowrap>計畫總經費合計<br>(千元)</th>
                    <th nowrap>縣市補助經費<br>佔總補助經費比例</th>
                    <th nowrap>縣市總經費<br>佔總經費比例</th>
                </tr>
            </thead>
            <tbody></tbody>
        </table>
    </div>
</asp:Content>

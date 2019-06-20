<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="SubsidyCategoryAnalyze.aspx.cs" Inherits="ISTI_CityNavigation.WebPage.SubsidyCategoryAnalyze" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            getData();
        });

        function getData() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetCategorySubMoney.aspx",
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
                                    tabstr += '<th nowrap>' + $(this).children("C_Type").text().trim() + '</th>';
                                }
                                // 總計
                                else {
                                    tabstr += '<tr class="spe">';
                                    tabstr += '<td nowrap align="center">' + $(this).children("C_Type").text().trim() + '</td>';
                                }
                                tabstr += '<td nowrap align="center">' + FormatNumber($(this).children("C_PlanCount").text().trim()) + '</td>';
                                tabstr += '<td nowrap align="right">' + FormatNumber(Number($(this).children("C_Subsidy").text().trim()).toFixed(1)) + '</td>';
                                tabstr += '<td nowrap align="right">' + FormatNumber(Number($(this).children("C_TotalMoney").text().trim()).toFixed(1)) + '</td>';
                                tabstr += '<td nowrap align="right">' + Number((parseFloat($(this).children("C_SubsidyRatio").text().trim()) * 100).toFixed(1)) + '%</td>';
                                tabstr += '<td nowrap align="right">' +  Number((parseFloat($(this).children("C_TotalMoneyRatio").text().trim()) * 100).toFixed(1)) + '%</td>';
                                tabstr += '</tr>';
                            });
                            $("#tablist tbody").empty();
                            $("#tablist tbody").append(tabstr);
                            // 固定表頭
                            // left : 左側兩欄固定(需為th)
                            $(".hugetable table").tableHeadFixer({ "left": 1 });
                        }
                        else
                            tabstr += '<tr><td colspan="6">查詢無資料</td></tr>';
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
    <div class="tabmenublockV2wrapper margin10T">
        <div class="tabmenublockV2 font-size3">
            <span class="SlimTabBtnV2"><a href="BudgetExecution.aspx" target="_self">智慧城鄉生活應用發展計畫_107-109年預計經費執行情形(本局18億)</a></span>
            <span class="SlimTabBtnV2"><a href="CitySubsidyAnalyze.aspx" target="_self">補助經費縣市分析</a></span>
            <span class="SlimTabBtnV2"><a href="SubsidyServiceAnalyze.aspx" target="_self">補助經費服務主軸分析</a></span>
            <span class="SlimTabBtnV2 SlimTabBtnV2Current"><a>補助經費計畫類別分析</a></span>
        </div><!-- tabmenublock -->
    </div><!-- tabmenublockV2wrapper -->

    <div class="stripeMeCS hugetable maxHeightD scrollbar-outer font-normal margin20T margin10B">
        <table id="tablist" border="0" cellspacing="0" cellpadding="0" width="100%">
            <thead>
                <tr>
                    <th nowrap>應用服務別</th>
                    <th nowrap>計畫數</th>
                    <th nowrap>補助款(千元)</th>
                    <th nowrap>總經費(千元)</th>
                    <th nowrap>應用服務別<br>佔總補助經費比例</th>
                    <th nowrap>應用服務別<br>佔總經費比例</th>
                </tr>
            </thead>
            <tbody></tbody>
        </table>
    </div>
</asp:Content>

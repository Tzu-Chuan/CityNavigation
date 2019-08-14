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
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                if (i != $(data).find("data_item").length - 1) {
                                    tabstr += '<tr>';
                                    tabstr += '<th nowrap>' + $(this).children("C_City").text().trim() + '</th>';
                                    tabstr += '<td nowrap align="center">' + $.FormatThousandGroup($(this).children("C_PlanCount_NotAll").text().trim()) + '</td>';
                                    tabstr += '<td nowrap align="right">' + $.FormatThousandGroup(Number($(this).children("C_SubMoney_NotAll").text().trim()).toFixed(0)) + '</td>';
                                    tabstr += '<td nowrap align="right">' + $.FormatThousandGroup(Number($(this).children("C_PlanMoney_NotAll").text().trim()).toFixed(0)) + '</td>';
                                    tabstr += '<td nowrap align="right">' + $.FormatThousandGroup(Number($(this).children("C_AssignSubMoney").text().trim()).toFixed(0)) + '</td>';
                                    tabstr += '<td nowrap align="right">' + $.FormatThousandGroup(Number($(this).children("C_AssignTotalMoney").text().trim()).toFixed(0)) + '</td>';
                                    tabstr += '<td nowrap align="center">' + (parseFloat($(this).children("C_CitySubMoneyRatio_NotAll").text().trim()) * 100).toFixed(1) + '%</td>';
                                    tabstr += '<td nowrap align="center">' + (parseFloat($(this).children("C_CityTotalMoneyRatio_NotAll").text().trim()) * 100).toFixed(1) + '%</td>';
                                    tabstr += '<td nowrap align="center">' + $.FormatThousandGroup($(this).children("C_PlanCount").text().trim()) + '</td>';
                                    tabstr += '<td nowrap align="right">' + $.FormatThousandGroup(Number($(this).children("C_SubMoney").text().trim()).toFixed(0)) + '</td>';
                                    tabstr += '<td nowrap align="right">' + $.FormatThousandGroup(Number($(this).children("C_PlanMoney").text().trim()).toFixed(0)) + '</td>';
                                    tabstr += '<td nowrap align="center">' + (parseFloat($(this).children("C_CitySubMoneyRatio").text().trim()) * 100).toFixed(1) + '%</td>';
                                    tabstr += '<td nowrap align="center">' + (parseFloat($(this).children("C_CityTotalMoneyRatio").text().trim()) * 100).toFixed(1) + '%</td>';
                                    tabstr += '</tr>';
                                }
                                // 合計
                                else {
                                    tabstr += '<tr class="spe">';
                                    tabstr += '<td nowrap align="center">' + $(this).children("C_City").text().trim() + '</td>';
                                    tabstr += '<td nowrap align="center">' + $.FormatThousandGroup($(this).children("C_PlanCount_NotAll").text().trim()) + '</td>';
                                    tabstr += '<td nowrap align="right">' + $.FormatThousandGroup(Number($(this).children("C_SubMoney_NotAll").text().trim()).toFixed(0)) + '</td>';
                                    tabstr += '<td nowrap align="right">' + $.FormatThousandGroup(Number($(this).children("C_PlanMoney_NotAll").text().trim()).toFixed(0)) + '</td>';
                                    tabstr += '<td nowrap align="right">' + $.FormatThousandGroup(Number($(this).children("C_AssignSubMoney").text().trim()).toFixed(0)) + '</td>';
                                    tabstr += '<td nowrap align="right">' + $.FormatThousandGroup(Number($(this).children("C_AssignTotalMoney").text().trim()).toFixed(0)) + '</td>';
                                    tabstr += '<td nowrap align="center">' + (parseFloat($(this).children("C_CitySubMoneyRatio_NotAll").text().trim()) * 100).toFixed(0) + '%</td>';
                                    tabstr += '<td nowrap align="center">' + (parseFloat($(this).children("C_CityTotalMoneyRatio_NotAll").text().trim()) * 100).toFixed(0) + '%</td>';
                                    tabstr += '<td nowrap align="center">' + $.FormatThousandGroup($(this).children("C_PlanCount").text().trim()) + '</td>';
                                    tabstr += '<td nowrap align="right">' + $.FormatThousandGroup(Number($(this).children("C_SubMoney").text().trim()).toFixed(0)) + '</td>';
                                    tabstr += '<td nowrap align="right">' + $.FormatThousandGroup(Number($(this).children("C_PlanMoney").text().trim()).toFixed(0)) + '</td>';
                                    tabstr += '<td nowrap align="center">' + (parseFloat($(this).children("C_CitySubMoneyRatio").text().trim()) * 100).toFixed(0) + '%</td>';
                                    tabstr += '<td nowrap align="center">' + (parseFloat($(this).children("C_CityTotalMoneyRatio").text().trim()) * 100).toFixed(0) + '%</td>';
                                    tabstr += '</tr>';

                                    $("#plancount_txt").html($(this).children("C_PlanCount").text().trim());
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

    <div class="margin20T" style="font-size:12pt;">註1：各縣市補助經費係依該縣市人口數占比進行分攤計算</div>
    <div style="font-size:12pt;">註2：計畫總件數 <span id="plancount_txt"></span> 件，場域為全區 17 件</div>
    <div id="TabDiv" class="stripeMeCS hugetable maxHeightD scrollbar-outer font-normal margin5T margin10B">
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
    <div style="font-size:14pt; color:red; text-align:right">機密資料，不宜外流！</div>
</asp:Content>

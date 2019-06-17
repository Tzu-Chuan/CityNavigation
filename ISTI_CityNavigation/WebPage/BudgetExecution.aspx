<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="BudgetExecution.aspx.cs" Inherits="ISTI_CityNavigation.WebPage.BudgetExecution" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            //固定標頭
            $(".hugetable table").tableHeadFixer({ "left": 1 });//左側兩欄固定(需為th)
        });

        function getData() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetBudgetExecution.aspx",
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
                                tabstr += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
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
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
     <div class="tabmenublockV2wrapper margin10T">
           <div class="tabmenublockV2 font-size3">
               <span class="SlimTabBtnV2 SlimTabBtnV2Current"><a>智慧城鄉生活應用發展計畫_107-109年預計經費執行情形(本局18億)</a></span>
               <span class="SlimTabBtnV2"><a href="#" target="_self">補助經費縣市分析</a></span>
               <span class="SlimTabBtnV2"><a href="#" target="_self">補助經費服務主軸分析</a></span>
               <span class="SlimTabBtnV2"><a href="#" target="_self">補助經費計畫類別分析</a></span>
           </div><!-- tabmenublock -->
       </div><!-- tabmenublockV2wrapper -->

       <div class="stripeMeCS hugetable maxHeightD scrollbar-outer font-normal margin20T margin10B">
           <table border="0" cellspacing="0" cellpadding="0" width="100%">
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
               <tbody>
               <tr>
                   <th>新北市</th>
                   <td align="center">28</td>
                   <td align="right"> 297,549 </td>
                   <td align="right"> 804,391 </td>
                   <td align="right"> 49,678 </td>
                   <td align="right"> 133,178 </td>
                   <td align="right">9.7%</td>
                   <td align="right">9.6%</td>
                   <td align="center">45</td>
                   <td align="right"> 347,227 </td>
                   <td align="right"> 937,569 </td>
                   <td align="right">10.37%</td>
                   <td align="right">10.3%</td>
               </tr>
               <tr>
                   <th>台北市</th>
                   <td align="center">34</td>
                   <td align="right"> 330,934 </td>
                   <td align="right"> 902,484 </td>
                   <td align="right"> 33,882 </td>
                   <td align="right"> 90,832 </td>
                   <td align="right">10.8%</td>
                   <td align="right">10.8%</td>
                   <td align="center">51</td>
                   <td align="right"> 364,816 </td>
                   <td align="right"> 993,316 </td>
                   <td align="right">10.89%</td>
                   <td align="right">10.9%</td>
               </tr>
               <tr>
                   <th>桃園市</th>
                   <td align="center">27</td>
                   <td align="right"> 313,979 </td>
                   <td align="right"> 834,853 </td>
                   <td align="right"> 25,867 </td>
                   <td align="right"> 69,344 </td>
                   <td align="right">10.3%</td>
                   <td align="right">10.0%</td>
                   <td align="center">44</td>
                   <td align="right"> 339,846 </td>
                   <td align="right"> 904,197 </td>
                   <td align="right">10.15%</td>
                   <td align="right">9.9%</td>
               </tr>
               <tr>
                   <th>台中市</th>
                   <td align="center">23</td>
                   <td align="right"> 349,733 </td>
                   <td align="right"> 956,736 </td>
                   <td align="right"> 34,117 </td>
                   <td align="right"> 91,461 </td>
                   <td align="right">11.4%</td>
                   <td align="right">11.4%</td>
                   <td align="center">40</td>
                   <td align="right"> 383,850 </td>
                   <td align="right"> 1,048,197 </td>
                   <td align="right">11.46%</td>
                   <td align="right">11.5%</td>
               </tr>
               <tr>
                   <th>台南市</th>
                   <td align="center">20</td>
                   <td align="right"> 318,200 </td>
                   <td align="right"> 879,416 </td>
                   <td align="right"> 23,606 </td>
                   <td align="right"> 63,283 </td>
                   <td align="right">10.4%</td>
                   <td align="right">10.5%</td>
                   <td align="center">37</td>
                   <td align="right"> 341,806 </td>
                   <td align="right"> 942,699 </td>
                   <td align="right">10.21%</td>
                   <td align="right">10.3%</td>
               </tr>
               <tr>
                   <th>高雄市</th>
                   <td align="center">19</td>
                   <td align="right"> 246,903 </td>
                   <td align="right"> 680,449 </td>
                   <td align="right"> 34,822 </td>
                   <td align="right"> 93,350 </td>
                   <td align="right">8.1%</td>
                   <td align="right">8.1%</td>
                   <td align="center">36</td>
                   <td align="right"> 281,725 </td>
                   <td align="right"> 773,799 </td>
                   <td align="right">8.41%</td>
                   <td align="right">8.5%</td>
               </tr>
               <tr>
                   <th>宜蘭縣</th>
                   <td align="center">5</td>
                   <td align="right"> 82,910 </td>
                   <td align="right"> 227,681 </td>
                   <td align="right"> 4,959 </td>
                   <td align="right"> 13,333 </td>
                   <td align="right">2.7%</td>
                   <td align="right">2.7%</td>
                   <td align="center">22</td>
                   <td align="right"> 87,869 </td>
                   <td align="right"> 241,014 </td>
                   <td align="right">2.62%</td>
                   <td align="right">2.6%</td>
               </tr>
               <tr>
                   <th>新竹縣</th>
                   <td align="center">8</td>
                   <td align="right"> 94,088 </td>
                   <td align="right"> 252,841 </td>
                   <td align="right"> 6,724 </td>
                   <td align="right"> 18,025 </td>
                   <td align="right">3.1%</td>
                   <td align="right">3.0%</td>
                   <td align="center">25</td>
                   <td align="right"> 100,812 </td>
                   <td align="right"> 270,866 </td>
                   <td align="right">3.01%</td>
                   <td align="right">3.0%</td>
               </tr>
               <tr>
                   <th>苗栗縣</th>
                   <td align="center">7</td>
                   <td align="right"> 44,011 </td>
                   <td align="right"> 124,018 </td>
                   <td align="right"> 7,105 </td>
                   <td align="right"> 19,048 </td>
                   <td align="right">1.4%</td>
                   <td align="right">1.5%</td>
                   <td align="center">24</td>
                   <td align="right"> 51,116 </td>
                   <td align="right"> 143,066 </td>
                   <td align="right">1.53%</td>
                   <td align="right">1.6%</td>
               </tr>
               <tr>
                   <th>彰化縣</th>
                   <td align="center">12</td>
                   <td align="right"> 118,268 </td>
                   <td align="right"> 335,733 </td>
                   <td align="right"> 16,178 </td>
                   <td align="right"> 43,369 </td>
                   <td align="right">3.9%</td>
                   <td align="right">4.0%</td>
                   <td align="center">29</td>
                   <td align="right"> 134,446 </td>
                   <td align="right"> 379,102 </td>
                   <td align="right">4.01%</td>
                   <td align="right">4.1%</td>
               </tr>
               <tr>
                   <th>南投縣</th>
                   <td align="center">6</td>
                   <td align="right"> 40,720 </td>
                   <td align="right"> 111,200 </td>
                   <td align="right"> 5,541 </td>
                   <td align="right"> 14,898 </td>
                   <td align="right">1.3%</td>
                   <td align="right">1.3%</td>
                   <td align="center">23</td>
                   <td align="right"> 46,261 </td>
                   <td align="right"> 126,098 </td>
                   <td align="right">1.38%</td>
                   <td align="right">1.4%</td>
               </tr>
               <tr>
                   <th>雲林縣</th>
                   <td align="center">12</td>
                   <td align="right"> 174,574 </td>
                   <td align="right"> 475,834 </td>
                   <td align="right"> 8,808 </td>
                   <td align="right"> 23,613 </td>
                   <td align="right">5.7%</td>
                   <td align="right">5.7%</td>
                   <td align="center">29</td>
                   <td align="right"> 183,382 </td>
                   <td align="right"> 499,447 </td>
                   <td align="right">5.48%</td>
                   <td align="right">5.5%</td>
               </tr>
               <tr>
                   <th>嘉義縣</th>
                   <td align="center">10</td>
                   <td align="right"> 70,012 </td>
                   <td align="right"> 199,261 </td>
                   <td align="right"> 6,547 </td>
                   <td align="right"> 17,552 </td>
                   <td align="right">2.3%</td>
                   <td align="right">2.4%</td>
                   <td align="center">27</td>
                   <td align="right"> 76,559 </td>
                   <td align="right"> 216,813 </td>
                   <td align="right">2.29%</td>
                   <td align="right">2.4%</td>
               </tr>
               <tr>
                   <th>屏東縣</th>
                   <td align="center">9</td>
                   <td align="right"> 108,576 </td>
                   <td align="right"> 289,001 </td>
                   <td align="right"> 9,134 </td>
                   <td align="right"> 24,558 </td>
                   <td align="right">3.5%</td>
                   <td align="right">3.5%</td>
                   <td align="center">26</td>
                   <td align="right"> 117,710 </td>
                   <td align="right"> 313,559 </td>
                   <td align="right">3.51%</td>
                   <td align="right">3.4%</td>
               </tr>
               <tr>
                   <th>台東縣</th>
                   <td align="center">7</td>
                   <td align="right"> 63,540 </td>
                   <td align="right"> 168,088 </td>
                   <td align="right"> 2,429 </td>
                   <td align="right"> 6,531 </td>
                   <td align="right">2.1%</td>
                   <td align="right">2.0%</td>
                   <td align="center">24</td>
                   <td align="right"> 65,969 </td>
                   <td align="right"> 174,619 </td>
                   <td align="right">1.97%</td>
                   <td align="right">1.9%</td>
               </tr>
               <tr>
                   <th>花蓮縣</th>
                   <td align="center">6</td>
                   <td align="right"> 84,100 </td>
                   <td align="right"> 229,213 </td>
                   <td align="right"> 3,593 </td>
                   <td align="right"> 9,660 </td>
                   <td align="right">2.7%</td>
                   <td align="right">2.7%</td>
                   <td align="center">23</td>
                   <td align="right"> 87,693 </td>
                   <td align="right"> 238,873 </td>
                   <td align="right">2.62%</td>
                   <td align="right">2.6%</td>
               </tr>
               <tr>
                   <th>澎湖縣</th>
                   <td align="center">3</td>
                   <td align="right"> 8,582 </td>
                   <td align="right"> 23,391 </td>
                   <td align="right"> 1,001 </td>
                   <td align="right"> 2,677 </td>
                   <td align="right">0.3%</td>
                   <td align="right">0.3%</td>
                   <td align="center">20</td>
                   <td align="right"> 9,583 </td>
                   <td align="right"> 26,068 </td>
                   <td align="right">0.29%</td>
                   <td align="right">0.3%</td>
               </tr>
               <tr>
                   <th>基隆市</th>
                   <td align="center">4</td>
                   <td align="right"> 100,832 </td>
                   <td align="right"> 282,087 </td>
                   <td align="right"> 4,023 </td>
                   <td align="right"> 10,816 </td>
                   <td align="right">3.3%</td>
                   <td align="right">3.4%</td>
                   <td align="center">21</td>
                   <td align="right"> 104,855 </td>
                   <td align="right"> 292,903 </td>
                   <td align="right">3.13%</td>
                   <td align="right">3.2%</td>
               </tr>
               <tr>
                   <th>新竹市</th>
                   <td align="center">11</td>
                   <td align="right"> 99,906 </td>
                   <td align="right"> 282,852 </td>
                   <td align="right"> 4,655 </td>
                   <td align="right"> 12,517 </td>
                   <td align="right">3.3%</td>
                   <td align="right">3.4%</td>
                   <td align="center">28</td>
                   <td align="right"> 104,561 </td>
                   <td align="right"> 295,369 </td>
                   <td align="right">3.12%</td>
                   <td align="right">3.2%</td>
               </tr>
               <tr>
                   <th>嘉義市</th>
                   <td align="center">11</td>
                   <td align="right"> 76,066 </td>
                   <td align="right"> 209,012 </td>
                   <td align="right"> 2,935 </td>
                   <td align="right"> 7,891 </td>
                   <td align="right">2.5%</td>
                   <td align="right">2.5%</td>
                   <td align="center">28</td>
                   <td align="right"> 79,001 </td>
                   <td align="right"> 216,903 </td>
                   <td align="right">2.36%</td>
                   <td align="right">2.4%</td>
               </tr>
               <tr>
                   <th>金門縣</th>
                   <td align="center">0</td>
                   <td align="right"> - </td>
                   <td align="right"> - </td>
                   <td align="right"> 1,280 </td>
                   <td align="right"> 3,425 </td>
                   <td align="right">0.0%</td>
                   <td align="right">0.0%</td>
                   <td align="center">17</td>
                   <td align="right"> 1,280 </td>
                   <td align="right"> 3,425 </td>
                   <td align="right">0.04%</td>
                   <td align="right">0.0%</td>
               </tr>
               <tr>
                   <th>連江縣</th>
                   <td align="center">4</td>
                   <td align="right"> 38,334 </td>
                   <td align="right"> 100,835 </td>
                   <td align="right"> 107 </td>
                   <td align="right"> 289 </td>
                   <td align="right">1.3%</td>
                   <td align="right">1.2%</td>
                   <td align="center">21</td>
                   <td align="right"> 38,441 </td>
                   <td align="right"> 101,124 </td>
                   <td align="right">1.15%</td>
                   <td align="right">1.1%</td>
               </tr>
               <tr class="spe">
                   <td>合計</td>
                   <td align="center"> 266 </td>
                   <td align="right"> 3,061,817 </td>
                   <td align="right"> 8,369,375 </td>
                   <td align="right"> 286,991 </td>
                   <td align="right"> 769,650 </td>
                   <td align="right">100%</td>
                   <td align="right">100%</td>
                   <td align="center"> 640 </td>
                   <td align="right"> 3,348,808 </td>
                   <td align="right"> 9,139,025 </td>
                   <td align="right">100%</td>
                   <td align="right">100%</td>
               </tr>
               </tbody>
           </table>
       </div>
</asp:Content>

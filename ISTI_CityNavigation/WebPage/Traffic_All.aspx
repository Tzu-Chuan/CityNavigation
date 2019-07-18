<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="Traffic_All.aspx.cs" Inherits="ISTI_CityNavigation.WebPage.Traffic_All" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
<script type="text/javascript">
    $(document).ready(function () {
            /// 表頭排序設定
            Page.Option.SortMethod = "+";
            Page.Option.SortName = "Tra_CityNo";

            getData();

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
                getData();
            });

            //圓餅圖
            $('#stackedcolumn1').highcharts({
                chart: {
                    type: 'pie'
                },
                title: {
                    text: '小汽車路邊及路外停車位'
                },
                series: [{
                    name: '',
                    colorByPoint: true,
                    data: [
                        {
                            name: '臺北市',
                            y: parseFloat(Travel_All_Array[1])
                        },
                        {
                            name: '新北市',
                            y: parseFloat(Travel_All_Array[0])
                        },
                        {
                            name: '基隆市',
                            y: parseFloat(Travel_All_Array[17])
                        },
                        {
                            name: '桃園市',
                            y: parseFloat(Travel_All_Array[2])
                        },
                        {
                            name: '宜蘭縣',
                            y: parseFloat(Travel_All_Array[6])
                        },
                        {
                            name: '新竹縣',
                            y: parseFloat(Travel_All_Array[7])
                        },
                        {
                            name: '新竹市',
                            y: parseFloat(Travel_All_Array[18])
                        },
                        {
                            name: '苗栗縣',
                            y: parseFloat(Travel_All_Array[8])
                        },
                        {
                            name: '臺中市',
                            y: parseFloat(Travel_All_Array[3])
                        },
                        {
                            name: '彰化縣',
                            y: parseFloat(Travel_All_Array[9])
                        },
                        {
                            name: '南投縣',
                            y: parseFloat(Travel_All_Array[10])
                        },
                        {
                            name: '雲林縣',
                            y: parseFloat(Travel_All_Array[11])
                        },
                        {
                            name: '嘉義縣',
                            y: parseFloat(Travel_All_Array[12])
                        },
                        {
                            name: '嘉義市',
                            y: parseFloat(Travel_All_Array[19])
                        },
                        {
                            name: '臺南市',
                            y: parseFloat(Travel_All_Array[4])
                        },
                        {
                            name: '高雄市',
                            y: parseFloat(Travel_All_Array[5])
                        },
                        {
                            name: '屏東縣',
                            y: parseFloat(Travel_All_Array[13])
                        },
                        {
                            name: '花蓮縣',
                            y: parseFloat(Travel_All_Array[15])
                        },
                        {
                            name: '臺東縣',
                            y: parseFloat(Travel_All_Array[14])
                        },
                        {
                            name: '金門縣',
                            y: parseFloat(Travel_All_Array[20])
                        },
                        {
                            name: '連江縣',
                            y: parseFloat(Travel_All_Array[21])
                        },
                        {
                            name: '澎湖縣',
                            y: parseFloat(Travel_All_Array[16])
                        },
                    ]
                }]
            });
        }); //js end


        var Travel_All_Array = [];
        //撈觀光列表
        function getData() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetTrafficList.aspx",
                data: {
                    CityNo: "All",
                    SortName: Page.Option.SortName,
                    SortMethod: Page.Option.SortMethod,
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
                        $("#tablist tbody").empty();
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Tra_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Tra_CarParkSpaceYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($(this).children("Tra_CarParkSpace").text().trim()).toFixed(0)) + '個' + '</td>';
                                Travel_All_Array.push($(this).children("Tra_CarParkSpace").text().trim().toString());
                                tabstr += '</td></tr>';
                            });
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        $("#tablist tbody").append(tabstr);
                        // 固定表頭
                        // left : 左側兩欄固定(需為th)
                        $(".hugetable table").tableHeadFixer({ "left": 0 });
                    }
                }
            })
        }
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
     <input type="hidden" id="tmpGuid" />
    <div class="WrapperBody" id="WrapperBody">
        <div class="container margin15T" id="ContentWrapper">
            <div class="twocol titleLineA">
                <div class="left"><span class="font-size4">全國資料</span></div>
                <!-- left -->
                <div class="right"><a href="CityInfo.aspx?city=02">首頁</a> / 全國資料 / 交通</div>
                <!-- right -->
            </div>
            <!-- twocol -->
            <div style="margin-top: 10px;">
                檔案類別：
        <select id="selType" name="selClass" class="inputex">
            <option value="01">小汽車路邊及路外停車位</option>
            <option value="02">通勤學民眾運具次數之公共運具市佔率</option>
            <option value="03">自小客車在居家附近每次尋找停車位時間</option>
            <option value="04">每萬輛小型車擁有路外及路邊停車位數</option>
            <option value="05">汽車登記數</option>
            <option value="06">每百人擁有汽車數</option>
            <option value="07">每百人擁有汽車數成長率</option>
            <option value="08">每萬輛機動車肇事數</option>
            <option value="09">每十萬人道路交通事故死傷人數</option>
        </select>
            </div>
            <div class="row margin10T ">
                <div class="col-lg-6 col-md-6 col-sm-12">
                    <div class="stripeMeCS hugetable maxHeightD scrollbar-outer font-normal">
                        <table border="0" cellspacing="0" cellpadding="0" width="100%" id="tablist">
                            <thead>
                                <tr>
                                    <th nowrap="nowrap" style="width: 40px;"><a href="javascript:void(0);" name="sortbtn" sortname="Tra_CityNo">縣市</a></th>
                                    <th nowrap="nowrap" style="width: 150px;">資料時間</th>
                                    <th nowrap="nowrap" style="width: 150px;"><a href="javascript:void(0);" name="sortbtn" sortname="Tra_CarParkSpace">小汽車路邊及路外停車位</a></th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
                <!-- col -->
                <div class="col-lg-6 col-md-6 col-sm-12">
                    <div id="stackedcolumn1" class="maxWithA"></div>
                </div>
                <!-- col -->
            </div>
            <!-- row -->
        </div>
    </div>
    <!-- WrapperBody -->
</asp:Content>

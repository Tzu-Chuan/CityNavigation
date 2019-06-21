<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="Population_All.aspx.cs" Inherits="ISTI_CityNavigation.WebPage.Population_All" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">

        $(document).ready(function () {
            getData();

            //寬版螢幕調整
            $(".container").css("max-width", "1440px");

            //等高區塊
            $('.euqalheightblock').matchHeight({
                byRow: true,//若為false,則所有區塊等高
                property: 'height',//使用min-height會出問題
                target: null,//設定等高對象:$('.sidebar')
                remove: false
            });

            //固定標頭
            $(".hugetable table").tableHeadFixer({ "left": 0 });//左側兩欄固定(需為th)

            //圓餅圖
            $('#stackedcolumn1').highcharts({
                chart: {
                    type: 'pie'
                },
                title: {
                    text: '全國人口比例'
                },

                series: [{
                    name: '',
                    colorByPoint: true,
                    data: [
                        {
                            name: '臺北市',
                            y: parseFloat(Population_All_Array[1])
                        },
                        {
                            name: '新北市',
                            y: parseFloat(Population_All_Array[0])
                        },
                        {
                            name: '基隆市',
                            y: parseFloat(Population_All_Array[17])
                        },
                        {
                            name: '桃園市',
                            y: parseFloat(Population_All_Array[2])
                        },
                        {
                            name: '宜蘭縣',
                            y: parseFloat(Population_All_Array[6])
                        },
                        {
                            name: '新竹縣',
                            y: parseFloat(Population_All_Array[7])
                        },
                        {
                            name: '新竹市',
                            y: parseFloat(Population_All_Array[18])
                        },
                        {
                            name: '苗栗縣',
                            y: parseFloat(Population_All_Array[8])
                        },
                        {
                            name: '臺中市',
                            y: parseFloat(Population_All_Array[3])
                        },
                        {
                            name: '彰化縣',
                            y: parseFloat(Population_All_Array[9])
                        },
                        {
                            name: '南投縣',
                            y: parseFloat(Population_All_Array[10])
                        },
                        {
                            name: '雲林縣',
                            y: parseFloat(Population_All_Array[11])
                        },
                        {
                            name: '嘉義縣',
                            y: parseFloat(Population_All_Array[12])
                        },
                        {
                            name: '嘉義市',
                            y: parseFloat(Population_All_Array[19])
                        },
                        {
                            name: '臺南市',
                            y: parseFloat(Population_All_Array[4])
                        },
                        {
                            name: '高雄市',
                            y: parseFloat(Population_All_Array[5])
                        },
                        {
                            name: '屏東縣',
                            y: parseFloat(Population_All_Array[13])
                        },
                        {
                            name: '花蓮縣',
                            y: parseFloat(Population_All_Array[15])
                        },
                        {
                            name: '臺東縣',
                            y: parseFloat(Population_All_Array[14])
                        },
                        {
                            name: '金門縣',
                            y: parseFloat(Population_All_Array[20])
                        },
                        {
                            name: '連江縣',
                            y: parseFloat(Population_All_Array[21])
                        },
                        {
                            name: '澎湖縣',
                            y: parseFloat(Population_All_Array[16])
                        },
                    ]
                }]

            });

        }); //js end


        var Population_All_Array = [];
        var CityNo = "All";
        //撈總人口列表
        function getData() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetPopulationList.aspx",
                data: {
                    CityNo: CityNo
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
                                tabstr += '<td align="left" nowrap="nowrap">' + $(this).children("P_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("P_TotalYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="right" nowrap="nowrap">' + FormatNumber(Number($(this).children("P_PeopleTotal").text().trim()).toFixed(0)) + '人' + '</td>';
                                Population_All_Array.push($(this).children("P_PeopleTotal").text().trim().toString());
                                tabstr += '</td></tr>';
                            })
                        }
                        else
                            tabstr += '<tr><td colspan="6">查詢無資料</td></tr>';
                        $("#tablist tbody").append(tabstr);
                    }
                }
            })
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
    <div class="WrapperBody" id="WrapperBody">
        <div class="container margin15T" id="ContentWrapper">

            <div class="twocol titleLineA">
                <div class="left"><span class="font-size4">全國人口</span></div>
                <!-- left -->
                <div class="right">首頁 / 全國人口</div>
                <!-- right -->
            </div>
            <!-- twocol -->


            <div class="row margin10T ">
                <div class="col-lg-6 col-md-6 col-sm-12">
                    <div class="stripeMeCS hugetable maxHeightD scrollbar-outer font-normal">
                        <table border="0" cellspacing="0" cellpadding="0" width="100%" id="tablist">
                            <thead>
                                <tr>
                                    <th nowrap="nowrap" style="width: 40px;">縣市</th>
                                    <th nowrap="nowrap" style="width: 150px;">資料時間</th>
                                    <th nowrap="nowrap" style="width: 150px;">人口數</th>
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
        <!-- ContentWrapper -->

        <div class="container-fluid">
            <div class="backTop"><a href="#" class="backTotop">TOP</a></div>
        </div>
    </div>
    <!-- WrapperBody -->
</asp:Content>

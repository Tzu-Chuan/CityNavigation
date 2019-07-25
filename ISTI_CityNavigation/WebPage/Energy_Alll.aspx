<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="Energy_Alll.aspx.cs" Inherits="ISTI_CityNavigation.WebPage.Energy_Alll" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            $(".CityClass").hide();

            /// 表頭排序設定
            Page.Option.SortMethod = "+";
            Page.Option.SortName = "Ene_CityNo";

            ///Highcharts千分位
            Highcharts.setOptions({
                lang: {
                    thousandsSep: ','
                }
            });

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
                switch ($("#selType").val()) {
                    case "01":
                        getData();
                        break;
                    case "02":
                        getTPCBuyElectricity();
                        break;
                    case "03":
                        getElectricityUsed();
                        break;
                    case "04":
                        getReEnergyOfElectricityRate();
                        break;
                }
            });

            defaultInfo();


            $(document).on("change", "#selType", function () {
                $(".CityClass").hide();
                Page.Option.SortMethod = "+";
                Page.Option.SortName = "Ene_CityNo";
                Energy_All_Array.length = 0;
                switch ($("#selType").val()) {
                    case "01":
                        document.getElementById("DeviceCapacityNum_tablist").style.display = "";
                        getData();
                        titlePie = "再生能源裝置容量數";
                        DrawChart(titlePie);
                        break;
                    case "02":
                        document.getElementById("TPCBuyElectricity_tablist").style.display = "";
                        getTPCBuyElectricity();
                        titlePie = "台電購入再生能源電量";
                        DrawChart(titlePie);
                        break;
                    case "03":
                        document.getElementById("ElectricityUsed_tablist").style.display = "";
                        getElectricityUsed();
                        titlePie = "用電量";
                        DrawChart(titlePie);
                        break;
                    case "04":
                        document.getElementById("ReEnergyOfElectricityRate_tablist").style.display = "";
                        getReEnergyOfElectricityRate();
                        titlePie = "再生能源電量佔用電量比例";
                        DrawChart(titlePie);
                        break;
                }
            });

        }); //js end


        var Energy_All_Array = [];
        function defaultInfo() {
            document.getElementById("DeviceCapacityNum_tablist").style.display = "";
            getData();
            titlePie = "再生能源裝置容量數";
            DrawChart(titlePie);
        }

        //再生能源裝置容量數
        function getData() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetEnergyList.aspx",
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
                        $("#DeviceCapacityNum_tablist tbody").empty();
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Ene_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Ene_DeviceCapacityNumYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($(this).children("Ene_DeviceCapacityNum").text().trim()).toFixed(0)) + '千瓦' + '</td>';
                                Energy_All_Array.push($(this).children("Ene_DeviceCapacityNum").text().trim().toString());
                                tabstr += '</td></tr>';
                            });
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        $("#DeviceCapacityNum_tablist tbody").append(tabstr);
                        // 固定表頭
                        // left : 左側兩欄固定(需為th)
                        $(".hugetable table").tableHeadFixer({ "left": 0 });
                    }
                }
            })
        }

        //台電購入再生能源電量
        function getTPCBuyElectricity() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetEnergyList.aspx",
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
                        $("#TPCBuyElectricity_tablist tbody").empty();
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Ene_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Ene_TPCBuyElectricityYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($(this).children("Ene_TPCBuyElectricity").text().trim()).toFixed(0)) + '度' + '</td>';
                                Energy_All_Array.push($(this).children("Ene_TPCBuyElectricity").text().trim().toString());
                                tabstr += '</td></tr>';
                            });
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        $("#TPCBuyElectricity_tablist tbody").append(tabstr);
                        // 固定表頭
                        // left : 左側兩欄固定(需為th)
                        $(".hugetable table").tableHeadFixer({ "left": 0 });
                    }
                }
            })
        }

        //用電量
        function getElectricityUsed() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetEnergyList.aspx",
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
                        $("#ElectricityUsed_tablist tbody").empty();
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Ene_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Ene_ElectricityUsedYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($(this).children("Ene_ElectricityUsed").text().trim()).toFixed(0)) + '度' + '</td>';
                                Energy_All_Array.push($(this).children("Ene_ElectricityUsed").text().trim().toString());
                                tabstr += '</td></tr>';
                            });
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        $("#ElectricityUsed_tablist tbody").append(tabstr);
                        // 固定表頭
                        // left : 左側兩欄固定(需為th)
                        $(".hugetable table").tableHeadFixer({ "left": 0 });
                    }
                }
            })
        }

        //再生能源電量佔用電量比例
        function getReEnergyOfElectricityRate() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetEnergyList.aspx",
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
                        $("#ReEnergyOfElectricityRate_tablist tbody").empty();
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Ene_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Ene_ReEnergyOfElectricityRateYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($(this).children("Ene_ReEnergyOfElectricityRate").text().trim()).toFixed(2)) + '%' + '</td>';
                                Energy_All_Array.push($(this).children("Ene_ReEnergyOfElectricityRate").text().trim().toString());
                                tabstr += '</td></tr>';
                            });
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        $("#ReEnergyOfElectricityRate_tablist tbody").append(tabstr);
                        // 固定表頭
                        // left : 左側兩欄固定(需為th)
                        $(".hugetable table").tableHeadFixer({ "left": 0 });
                    }
                }
            })
        }


        //highcharts
        function DrawChart(titlePie) {
            $('#stackedcolumn1').highcharts({
                chart: {
                    type: 'pie'
                },
                title: {
                    text: titlePie
                },
                series: [{
                    name: '',
                    colorByPoint: true,
                    data: [
                        {
                            name: '臺北市',
                            y: parseFloat(Energy_All_Array[1])
                        },
                        {
                            name: '新北市',
                            y: parseFloat(Energy_All_Array[0])
                        },
                        {
                            name: '基隆市',
                            y: parseFloat(Energy_All_Array[17])
                        },
                        {
                            name: '桃園市',
                            y: parseFloat(Energy_All_Array[2])
                        },
                        {
                            name: '宜蘭縣',
                            y: parseFloat(Energy_All_Array[6])
                        },
                        {
                            name: '新竹縣',
                            y: parseFloat(Energy_All_Array[7])
                        },
                        {
                            name: '新竹市',
                            y: parseFloat(Energy_All_Array[18])
                        },
                        {
                            name: '苗栗縣',
                            y: parseFloat(Energy_All_Array[8])
                        },
                        {
                            name: '臺中市',
                            y: parseFloat(Energy_All_Array[3])
                        },
                        {
                            name: '彰化縣',
                            y: parseFloat(Energy_All_Array[9])
                        },
                        {
                            name: '南投縣',
                            y: parseFloat(Energy_All_Array[10])
                        },
                        {
                            name: '雲林縣',
                            y: parseFloat(Energy_All_Array[11])
                        },
                        {
                            name: '嘉義縣',
                            y: parseFloat(Energy_All_Array[12])
                        },
                        {
                            name: '嘉義市',
                            y: parseFloat(Energy_All_Array[19])
                        },
                        {
                            name: '臺南市',
                            y: parseFloat(Energy_All_Array[4])
                        },
                        {
                            name: '高雄市',
                            y: parseFloat(Energy_All_Array[5])
                        },
                        {
                            name: '屏東縣',
                            y: parseFloat(Energy_All_Array[13])
                        },
                        {
                            name: '花蓮縣',
                            y: parseFloat(Energy_All_Array[15])
                        },
                        {
                            name: '臺東縣',
                            y: parseFloat(Energy_All_Array[14])
                        },
                        {
                            name: '金門縣',
                            y: parseFloat(Energy_All_Array[20])
                        },
                        {
                            name: '連江縣',
                            y: parseFloat(Energy_All_Array[21])
                        },
                        {
                            name: '澎湖縣',
                            y: parseFloat(Energy_All_Array[16])
                        },
                    ]
                }]
            });
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
                <div class="right"><a href="CityInfo.aspx?city=02">首頁</a> / 全國資料 / 能源</div>
                <!-- right -->
            </div>
            <!-- twocol -->
            <div style="margin-top: 10px;">
                類別：
        <select id="selType" name="selClass" class="inputex">
            <option value="01">再生能源裝置容量數</option>
            <option value="02">台電購入再生能源電量</option>
            <option value="03">用電量</option>
            <option value="04">再生能源電量佔用電量比例</option>
        </select>
            </div>
            <div class="row margin10T ">
                <div class="col-lg-6 col-md-6 col-sm-12">
                    <div class="stripeMeCS hugetable maxHeightD scrollbar-outer font-normal">
                        <%--再生能源裝置容量數--%>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%" id="DeviceCapacityNum_tablist" class="CityClass">
                            <thead>
                                <tr>
                                    <th nowrap="nowrap" style="width: 40px;"><a href="javascript:void(0);" name="sortbtn" sortname="Ene_CityNo">縣市</a></th>
                                    <th nowrap="nowrap" style="width: 150px;">資料時間</th>
                                    <th nowrap="nowrap" style="width: 150px;"><a href="javascript:void(0);" name="sortbtn" sortname="Ene_DeviceCapacityNum">再生能源裝置容量數</a></th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                        <%--台電購入再生能源電量--%>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%" id="TPCBuyElectricity_tablist" class="CityClass">
                            <thead>
                                <tr>
                                    <th nowrap="nowrap" style="width: 40px;"><a href="javascript:void(0);" name="sortbtn" sortname="Ene_CityNo">縣市</a></th>
                                    <th nowrap="nowrap" style="width: 150px;">資料時間</th>
                                    <th nowrap="nowrap" style="width: 150px;"><a href="javascript:void(0);" name="sortbtn" sortname="Ene_TPCBuyElectricity">台電購入再生能源電量</a></th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                        <%--用電量--%>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%" id="ElectricityUsed_tablist" class="CityClass">
                            <thead>
                                <tr>
                                    <th nowrap="nowrap" style="width: 40px;"><a href="javascript:void(0);" name="sortbtn" sortname="Ene_CityNo">縣市</a></th>
                                    <th nowrap="nowrap" style="width: 150px;">資料時間</th>
                                    <th nowrap="nowrap" style="width: 150px;"><a href="javascript:void(0);" name="sortbtn" sortname="Ene_ElectricityUsed">用電量</a></th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                        <%--再生能源電量佔用電量比例--%>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%" id="ReEnergyOfElectricityRate_tablist" class="CityClass">
                            <thead>
                                <tr>
                                    <th nowrap="nowrap" style="width: 40px;"><a href="javascript:void(0);" name="sortbtn" sortname="Ene_CityNo">縣市</a></th>
                                    <th nowrap="nowrap" style="width: 150px;">資料時間</th>
                                    <th nowrap="nowrap" style="width: 150px;"><a href="javascript:void(0);" name="sortbtn" sortname="Ene_ReEnergyOfElectricityRate">再生能源電量佔用電量比例</a></th>
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

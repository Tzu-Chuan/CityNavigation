<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="Industry_All.aspx.cs" Inherits="ISTI_CityNavigation.WebPage.Industry_All" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            $(".CityClass").hide();

            /// 表頭排序設定
            Page.Option.SortMethod = "+";
            Page.Option.SortName = "Ind_CityNo";

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
                        getIncome();
                        break;
                    case "03":
                        getSales();
                        break;
                    case "04":
                        getBusiness();
                        break;
                }
            });

            defaultInfo();

            $(document).on("change", "#selType", function () {
                $(".CityClass").hide();
                Page.Option.SortName = "Ind_CityNo";
                Page.Option.SortMethod = "+";
                Industry_All_Array.length = 0;
                $('#stackedcolumn1').hide();
                switch ($("#selType").val()) {
                    case "01":
                        document.getElementById("Factory_tablist").style.display = "";
                        getData();
                        titlePie = "營運中工廠家數";
                        DrawChart(titlePie);
                        $('#stackedcolumn1').show();
                        break;
                    case "02":
                        document.getElementById("Income_tablist").style.display = "";
                        getIncome();
                        titlePie = "工廠營業收入";
                        DrawChart(titlePie);
                        $('#stackedcolumn1').show();
                        break;
                    case "03":
                        document.getElementById("Sales_tablist").style.display = "";
                        getSales();
                        titlePie = "營利事業銷售額";
                        DrawChart(titlePie);
                        $('#stackedcolumn1').show();
                        break;
                    case "04":
                        document.getElementById("Business_tablist").style.display = "";
                        getBusiness();
                        break;
                }
            });
        }); //js end


        var Industry_All_Array = [];
        function defaultInfo() {
            document.getElementById("Factory_tablist").style.display = "";
            getData();
            titlePie = "營運中工廠家數";
            DrawChart(titlePie);
        }
        //營運中工廠家數
        function getData() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetIndustryList.aspx",
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
                        $("#Factory_tablist tbody").empty();
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Ind_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Ind_FactoryYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($(this).children("Ind_Factory").text().trim()).toFixed(0)) + '家' + '</td>';
                                Industry_All_Array.push($(this).children("Ind_Factory").text().trim().toString());
                                tabstr += '</td></tr>';
                            });
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        $("#Factory_tablist tbody").append(tabstr);
                        // 固定表頭
                        // left : 左側兩欄固定(需為th)
                        $(".hugetable table").tableHeadFixer({ "left": 0 });
                    }
                }
            })
        }

        //工廠營業收入
        function getIncome() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetIndustryList.aspx",
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
                        $("#Income_tablist tbody").empty();
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Ind_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Ind_IncomeYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($(this).children("Ind_Income").text().trim()).toFixed(0)) + '千元' + '</td>';
                                Industry_All_Array.push($(this).children("Ind_Income").text().trim().toString());
                                tabstr += '</td></tr>';

                            });
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        $("#Income_tablist tbody").append(tabstr);
                        // 固定表頭
                        // left : 左側兩欄固定(需為th)
                        $(".hugetable table").tableHeadFixer({ "left": 0 });
                    }
                }
            })
        }

        //營利事業銷售額
        function getSales() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetIndustryList.aspx",
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
                        $("#Sales_tablist tbody").empty();
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Ind_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Ind_SalesYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($(this).children("Ind_Sales").text().trim()).toFixed(0)) + '千元' + '</td>';
                                Industry_All_Array.push($(this).children("Ind_Sales").text().trim().toString());
                                tabstr += '</td></tr>';

                            });
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        $("#Sales_tablist tbody").append(tabstr);
                        // 固定表頭
                        // left : 左側兩欄固定(需為th)
                        $(".hugetable table").tableHeadFixer({ "left": 0 });
                    }
                }
            })
        }

        //形成群聚之產業(依工研院產科國際所群聚資料)
        function getBusiness() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetIndustryList.aspx",
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
                        $("#Business_tablist tbody").empty();
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Ind_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Ind_BusinessYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Ind_Business").text().trim() + '</td>';
                                tabstr += '</td></tr>';
                            });
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        $("#Business_tablist tbody").append(tabstr);
                        // 固定表頭
                        // left : 左側兩欄固定(需為th)
                        $(".hugetable table").tableHeadFixer({ "left": 0 });
                    }
                }
            })
        }

        //highcharts
        function DrawChart() {
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
                            y: parseFloat(Industry_All_Array[1])
                        },
                        {
                            name: '新北市',
                            y: parseFloat(Industry_All_Array[0])
                        },
                        {
                            name: '基隆市',
                            y: parseFloat(Industry_All_Array[17])
                        },
                        {
                            name: '桃園市',
                            y: parseFloat(Industry_All_Array[2])
                        },
                        {
                            name: '宜蘭縣',
                            y: parseFloat(Industry_All_Array[6])
                        },
                        {
                            name: '新竹縣',
                            y: parseFloat(Industry_All_Array[7])
                        },
                        {
                            name: '新竹市',
                            y: parseFloat(Industry_All_Array[18])
                        },
                        {
                            name: '苗栗縣',
                            y: parseFloat(Industry_All_Array[8])
                        },
                        {
                            name: '臺中市',
                            y: parseFloat(Industry_All_Array[3])
                        },
                        {
                            name: '彰化縣',
                            y: parseFloat(Industry_All_Array[9])
                        },
                        {
                            name: '南投縣',
                            y: parseFloat(Industry_All_Array[10])
                        },
                        {
                            name: '雲林縣',
                            y: parseFloat(Industry_All_Array[11])
                        },
                        {
                            name: '嘉義縣',
                            y: parseFloat(Industry_All_Array[12])
                        },
                        {
                            name: '嘉義市',
                            y: parseFloat(Industry_All_Array[19])
                        },
                        {
                            name: '臺南市',
                            y: parseFloat(Industry_All_Array[4])
                        },
                        {
                            name: '高雄市',
                            y: parseFloat(Industry_All_Array[5])
                        },
                        {
                            name: '屏東縣',
                            y: parseFloat(Industry_All_Array[13])
                        },
                        {
                            name: '花蓮縣',
                            y: parseFloat(Industry_All_Array[15])
                        },
                        {
                            name: '臺東縣',
                            y: parseFloat(Industry_All_Array[14])
                        },
                        {
                            name: '金門縣',
                            y: parseFloat(Industry_All_Array[20])
                        },
                        {
                            name: '連江縣',
                            y: parseFloat(Industry_All_Array[21])
                        },
                        {
                            name: '澎湖縣',
                            y: parseFloat(Industry_All_Array[16])
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
                <div class="right"><a href="CityInfo.aspx?city=02">首頁</a> / 全國資料 / 產業</div>
                <!-- right -->
            </div>
            <!-- twocol -->
            <div style="margin-top: 10px;">
                類別：
        <select id="selType" name="selClass" class="inputex">
            <option value="01">營運中工廠家數</option>
            <option value="02">工廠營業收入</option>
            <option value="03">營利事業銷售額</option>
            <option value="04">形成群聚之產業(依工研院產科國際所群聚資料)</option>
        </select>
            </div>
            <div class="row margin10T ">
                <div class="col-lg-6 col-md-6 col-sm-12">
                    <div class="stripeMeCS hugetable maxHeightD scrollbar-outer font-normal">
                        <%--營運中工廠家數--%>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%" id="Factory_tablist" class="CityClass">
                            <thead>
                                <tr>
                                    <th nowrap="nowrap" style="width: 40px;"><a href="javascript:void(0);" name="sortbtn" sortname="Ind_CityNo">縣市</a></th>
                                    <th nowrap="nowrap" style="width: 150px;">資料時間</th>
                                    <th nowrap="nowrap" style="width: 150px;"><a href="javascript:void(0);" name="sortbtn" sortname="Ind_Factory">營運中工廠家數</a></th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                        <%--工廠營業收入--%>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%" id="Income_tablist" class="CityClass">
                            <thead>
                                <tr>
                                    <th nowrap="nowrap" style="width: 40px;"><a href="javascript:void(0);" name="sortbtn" sortname="Ind_CityNo">縣市</a></th>
                                    <th nowrap="nowrap" style="width: 150px;">資料時間</th>
                                    <th nowrap="nowrap" style="width: 150px;"><a href="javascript:void(0);" name="sortbtn" sortname="Ind_Income">工廠營業收入</a></th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                        <%--營利事業銷售額--%>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%" id="Sales_tablist" class="CityClass">
                            <thead>
                                <tr>
                                    <th nowrap="nowrap" style="width: 40px;"><a href="javascript:void(0);" name="sortbtn" sortname="Ind_CityNo">縣市</a></th>
                                    <th nowrap="nowrap" style="width: 150px;">資料時間</th>
                                    <th nowrap="nowrap" style="width: 150px;"><a href="javascript:void(0);" name="sortbtn" sortname="Ind_Sales">營利事業銷售額</a></th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                        <%--形成群聚之產業(依工研院產科國際所群聚資料)--%>
                        <%--營利事業銷售額--%>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%" id="Business_tablist" class="CityClass">
                            <thead>
                                <tr>
                                    <th nowrap="nowrap" style="width: 40px;"><a href="javascript:void(0);" name="sortbtn" sortname="Ind_CityNo">縣市</a></th>
                                    <th nowrap="nowrap" style="width: 150px;">資料時間</th>
                                    <th nowrap="nowrap" style="width: 150px;"><a href="javascript:void(0);" name="sortbtn" sortname="Ind_Business">形成群聚之產業(依工研院產科國際所群聚資料)</a></th>
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

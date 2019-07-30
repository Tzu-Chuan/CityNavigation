<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="CityCSE.aspx.cs" Inherits="ISTI_CityNavigation.WebPage.CityCSE" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            getData();

            // 計畫查詢連結
            $(document).on("click", "a[name='PlanBtn']", function () {
                RedirectPlanList();
            });
        });// end js

        /// ISTI 成員
        function getData() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetCSE.aspx",
                data: {
                    City: $("#tmpCity").val(),
                    Type: $("#tmpType").val(),
                    Keyword: $("#tmpKey").val()
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
                        $("#tablist").empty();
                        if ($(data).find("data_item").length > 0) {
                            // 計畫資料
                            if ($("#UserMode").val() == "IDB") {
                                tabstr += '<tr><td>';
                                tabstr += '<a href="javascript:void(0);" name="PlanBtn">智慧城鄉計畫提案 / 計畫查詢</a>';
                                tabstr += '<br>查詢計畫總表';
                                tabstr += '</td></tr>';
                            }

                            // 全國資料
                            $(data).find("data_item").each(function (i) {
                                // 含縣市與類別
                                if ($("#tmpCity").val() != "" || $("#tmpType").val() != "") {
                                    tabstr += '<tr><td>';
                                    if ($("#tmpCity").val() != "") {
                                        tabstr += '<a href="CityInfoTable.aspx?city=' + $("#tmpCity").val() + '&listname=' + $(this).children("K_Code").text().trim() + '">' +
                                            $("#tmpCityName").val() + ' / ' + GetTypeName($(this).children("K_Code").text().trim()) + '</a>';
                                    }
                                    else if ($("#tmpType").val() != "") {
                                        tabstr += '<a href="' + $(this).children("K_Code").text().trim() + '_All.aspx">' +
                                            '全國資料 / ' + GetTypeName($(this).children("K_Code").text().trim()) + '</a>';
                                    }
                                    tabstr += '<br>' + ChangColor($(this).children("Keyword").text().trim());
                                    tabstr += '</td></tr>';
                                }
                                // 只有填關鍵字
                                else {
                                    tabstr += '<tr><td>';
                                    tabstr += '<a href="' + $(this).children("K_Code").text().trim() + '_All.aspx">' +
                                        '全國資料 / ' + GetTypeName($(this).children("K_Code").text().trim()) + '</a>';
                                    tabstr += '<br>' + ChangColor($(this).children("Keyword").text().trim());
                                    tabstr += '</td></tr>';

                                    tabstr += '<tr><td>';
                                    tabstr += '<a href="CityInfoTable.aspx?city=02&listname=' + $(this).children("K_Code").text().trim() + '">' +
                                        '各縣市 / ' + GetTypeName($(this).children("K_Code").text().trim()) + '</a>';
                                    tabstr += '<br>' + ChangColor($(this).children("Keyword").text().trim());
                                    tabstr += '</td></tr>';
                                }
                            });
                            $("#tablist").append(tabstr);
                        }
                        else {
                            if ($("#UserMode").val() == "ISTI")
                                $("#tablist").append("<tr><td>查詢無資料</td></td>");
                            else
                                RedirectPlanList();
                        }
                    }
                }
            });
        }

        function RedirectPlanList() {
            var cseCity = $('<input type="hidden" name="cseCity" value="' + $("#tmpCity").val() + '" />');
            var cseServiceType = $('<input type="hidden" name="cseServiceType" value="' + $("#tmpServiceType").val() + '" />');
            var cseSearchTxt = $('<input type="hidden" name="cseSearchTxt" value="' + $("#tmpKey").val() + '" />');
            var form = $("form")[0];

            form.appendChild(cseCity[0]);
            form.appendChild(cseServiceType[0]);
            form.appendChild(cseSearchTxt[0]);

            form.setAttribute("action", "CityPlanList.aspx");
            form.setAttribute("method", "post");
            form.setAttribute("enctype", "multipart/form-data");
            form.setAttribute("encoding", "multipart/form-data");
            form.submit();
        }

        function ChangColor(str) {
            var regex= new RegExp($("#tmpKey").val(), 'g');
            return str.replace(regex, '<span style="color:red;">' + $("#tmpKey").val() + '</span>');
        }

        function GetTypeName(str) {
            switch (str) {
                case "Population":
                    return "人口土地";
                    break;
                case "Industry":
                    return "產業";
                    break;
                case "Farming":
                    return "農業";
                    break;
                case "Travel":
                    return "觀光";
                    break;
                case "Health":
                    return "健康";
                    break;
                case "Retail":
                    return "零售";
                    break;
                case "Education":
                    return "教育";
                    break;
                case "Traffic":
                    return "交通";
                    break;
                case "Energy":
                    return "能源";
                    break;
                case "Safety":
                    return "智慧安全、治理";
                    break;
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <input id="UserMode" type="hidden" value="<%= mode %>" />
    <input id="tmpCity" type="hidden" value="<%= wCity %>" />
    <input id="tmpCityName" type="hidden" value="<%= cseCityName %>" />
    <input id="tmpType" type="hidden" value="<%= wType %>" />
    <input id="tmpServiceType" type="hidden" value="<%= wServiceType %>" />
    <input id="tmpKey" type="hidden" value="<%= SearchStr %>" />
    <div class="font-size3 margin10T">查詢結果</div>
    <div class="stripeMeCS hugetable  font-normal margin5T margin10B maxHeightD">
        <table id="tablist" border="0" cellspacing="0" cellpadding="0" width="100%"></table>
    </div>
</asp:Content>

$(document).ready(function () {
    //寬版螢幕調整
    $(".container").css("max-width", "1440px");

    getdll("02", "#webCity");
    getMasterServiceType();

    // 權限設定
    switch ($("#compstr").val()) {
        case "ISTI":
            $(".idbMode").hide();
            break;
        case "IDBsr":
            $("#ManageBtn").hide();
            break;
    }

    $(document).on("click", "#ManageBtn", function () {
        location.href = "../Manage/BackEndIndex.aspx";
    });

    $(document).on("click", "#signout_btn", function () {
        location.href = "../Handler/SignOut.aspx";
    });

    $(document).on("click", "a[name='ItemBtn']", function () {
        var city = $(this).parent().parent().attr("citycode");
        switch ($(this).text()) {
            case "人口土地":
                location.href = "CityInfoTable.aspx?city=" + city + "&listname=Population";
                break;
            case "產業":
                location.href = "CityInfoTable.aspx?city=" + city + "&listname=Industry";
                break;
            case "智慧城鄉計畫提案":
                location.href = "SmartCity.aspx?city=" + city;
                break;
            case "農業":
                location.href = "CityInfoTable.aspx?city=" + city + "&listname=Farming";
                break;
            case "觀光":
                location.href = "CityInfoTable.aspx?city=" + city + "&listname=Travel";
                break;
            case "健康":
                location.href = "CityInfoTable.aspx?city=" + city + "&listname=Health";
                break;
            case "零售":
                location.href = "CityInfoTable.aspx?city=" + city + "&listname=Retail";
                break;
            case "教育":
                location.href = "CityInfoTable.aspx?city=" + city + "&listname=Education";
                break;
            case "交通":
                location.href = "CityInfoTable.aspx?city=" + city + "&listname=Traffic";
                break;
            case "能源":
                location.href = "CityInfoTable.aspx?city=" + city + "&listname=Energy";
                break;
            case "智慧安全、治理":
                location.href = "CityInfoTable.aspx?city=" + city + "&listname=Safety";
                break;
        }
    });

    $(document).on("click", "a[name='linkbtn']", function () {
        location.href = "CityInfo.aspx?city=" + $(this).attr("city");
    });

    // 清除條件 Button
    $(document).on("click", "#ClearBtn", function () {
        $(".webstr").val("");
    });

    $(document).on("click", "#WebSearchbtn", function () {
        var Searchstatus = false;
        $(".webstr").each(function () {
            if (this.value != "") Searchstatus = true;
        });

        if (!Searchstatus) {
            alert("請輸入查詢條件");
        }
        else {
            // ISTI 成員
            if ($("#compstr").val() == "ISTI") {
                // 未輸入關鍵字
                if ($("#webSearchStr").val().trim() == "") {
                    if ($("#webCity").val() != "" && $("#webType").val() != "")
                        location.href = "CityInfoTable.aspx?city=" + $("#webCity").val() + "&listname=" + $("#webType").val();
                    else if ($("#webType").val() != "")
                        location.href = $("#webType").val() + "_All.aspx";
                    else
                        location.href = "CityInfo.aspx?city=" + $("#webCity").val();
                }
                // 關鍵字查詢
                else {
                    RedirectToCSE("ISTI");
                }
            }
            // IDB 成員
            else {
                // 未輸入關鍵字
                if ($("#webSearchStr").val().trim() == "") {
                    // 全國資料類別 & 領域別 皆為 Null
                    if ($("#webType").val() == "" && $("#webServiceType").val() == "")
                        RedirectToCSE("IDB");
                    // 全國資料類別 Null
                    else if ($("#webType").val() == "" && $("#webServiceType").val() != "") {
                        var cseCity = $('<input type="hidden" name="cseCity" value="' + $("#webCity").val() + '" />');
                        var cseServiceType = $('<input type="hidden" name="cseServiceType" value="' + $("#webServiceType").val() + '" />');
                        var cseSearchTxt = $('<input type="hidden" name="cseSearchTxt" value="' + $("#webSearchStr").val() + '" />');
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
                    // 領域別 Null
                    else if ($("#webType").val() != "" && $("#webServiceType").val() == ""){
                        if ($("#webCity").val() != "")
                            location.href = "CityInfoTable.aspx?city=" + $("#webCity").val() + "&listname=" + $("#webType").val();
                    }
                    // 全國資料類別 & 領域別 皆有值
                    else
                        RedirectToCSE("IDB");
                }
                // 關鍵字查詢
                else {
                    RedirectToCSE("IDB");
                }
            }
        }
    });
}); // end js

function RedirectToCSE(user) {
    var mode = $('<input type="hidden" name="mode" value="' + user + '" />');
    var wCity = $('<input type="hidden" name="wCity" value="' + $("#webCity").val() + '" />');
    var wType = $('<input type="hidden" name="wType" value="' + $("#webType").val() + '" />');
    var wServiceType = $('<input type="hidden" name="wServiceType" value="' + $("#webServiceType").val() + '" />');
    var searchTxt = $('<input type="hidden" name="searchTxt" value="' + $("#webSearchStr").val() + '" />');
    var form = $("form")[0];

    form.appendChild(mode[0]);
    form.appendChild(wType[0]);
    form.appendChild(wServiceType[0]);
    form.appendChild(wCity[0]);
    form.appendChild(searchTxt[0]);

    form.setAttribute("action", "CityCSE.aspx");
    form.setAttribute("method", "post");
    form.setAttribute("enctype", "multipart/form-data");
    form.setAttribute("encoding", "multipart/form-data");
    form.submit();
}

// ddl 領域別
function getMasterServiceType() {
    $.ajax({
        type: "POST",
        async: false, //在沒有返回值之前,不會執行下一步動作
        url: "../handler/GetServiceTypeDDL.aspx",
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
                var ddlstr = '<option value="">請選擇</option>';
                if ($(data).find("data_item").length > 0) {
                    $(data).find("data_item").each(function (i) {
                        ddlstr += '<option value="' + $(this).children("CS_ServiceType").text().trim() + '">' + $(this).children("CS_ServiceType").text().trim() + '</option>';
                    });
                    $("#webServiceType").empty();
                    $("#webServiceType").append(ddlstr);
                }
            }
        }
    });
}

// ddl 縣市
function getdll(gno, tagName) {
    $.ajax({
        type: "POST",
        async: false, //在沒有返回值之前,不會執行下一步動作
        url: "../handler/GetDDL.aspx",
        data: {
            Group: gno,
            Token: $("#InfoToken").val()
        },
        error: function (xhr) {
            alert("Error " + xhr.status);
            console.log(xhr.responseText);
        },
        success: function (data) {
            if ($(data).find("Error").length > 0) {
                alert($(data).find("Error").attr("Message"));
            }
            else {
                var ddlstr = '<option value="">請選擇</option>';
                if ($(data).find("data_item").length > 0) {
                    $(data).find("data_item").each(function (i) {
                        ddlstr += '<option value="' + $(this).children("C_Item").text().trim() + '">' + $(this).children("C_Item_cn").text().trim() + '</option>';
                    });
                    $(tagName).empty();
                    $(tagName).append(ddlstr);
                }
            }
        }
    });
}

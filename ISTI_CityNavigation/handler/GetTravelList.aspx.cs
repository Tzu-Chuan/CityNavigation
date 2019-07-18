using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;

namespace ISTI_CityNavigation.WebPage.wHandler
{
    public partial class GetTravelList : System.Web.UI.Page
    {
        Travel_DB n_db = new Travel_DB();
        Common com = new Common();
        protected void Page_Load(object sender, EventArgs e)
        {
            ///-----------------------------------------------------
            ///功    能: 撈觀光列表
            ///-----------------------------------------------------
            XmlDocument xDoc = new XmlDocument();
            try
            {
                string T_CityNo = (Request["CityNo"] != null) ? Request["CityNo"].ToString().Trim() : "";
                string SortName = (Request["SortName"] != null) ? Request["SortName"].ToString().Trim() : "";
                string SortMethod = (Request["SortMethod"] != null) ? Request["SortMethod"].ToString().Trim() : "-";
                string token = (string.IsNullOrEmpty(Request["Token"])) ? "" : Request["Token"].ToString().Trim();
                SortMethod = (SortMethod == "+") ? "asc" : "desc";

                DataTable dt = new DataTable();
                if (Common.VeriftyToken(token))
                {
                    n_db._T_CityNo = T_CityNo;
                    if (T_CityNo != "All")
                        dt = n_db.getTravelList();
                    else
                        dt = n_db.getTravel_All(SortName, SortMethod);
                    string xmlstr = string.Empty;
                    xmlstr = DataTableToXml.ConvertDatatableToXML(dt, "dataList", "data_item");
                    xmlstr = "<?xml version='1.0' encoding='utf-8'?><root>" + xmlstr + "</root>";
                    xDoc.LoadXml(xmlstr);
                }
                else
                {
                    xDoc = ExceptionUtil.GetErrorMassageDocument("TokenFail");
                }
            }

            catch (Exception ex)
            {
                xDoc = ExceptionUtil.GetExceptionDocument(ex);
            }

            Response.ContentType = System.Net.Mime.MediaTypeNames.Text.Xml;
            xDoc.Save(Response.Output);
        }
    }
}
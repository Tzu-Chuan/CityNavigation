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
    public partial class GetPopulationList : System.Web.UI.Page
    {
        Population_DB n_db = new Population_DB();
        Common com = new Common();
        protected void Page_Load(object sender, EventArgs e)
        {
            ///-----------------------------------------------------
            ///功    能: 撈全國人口列表
            ///-----------------------------------------------------
            XmlDocument xDoc = new XmlDocument();
            try
            {
                string P_CityNo = (Request["CityNo"] != null) ? Request["CityNo"].ToString().Trim() : "";
                string SortName = (Request["SortName"] != null) ? Request["SortName"].ToString().Trim() : "";
                string SortMethod = (Request["SortMethod"] != null) ? Request["SortMethod"].ToString().Trim() : "-";
                string token = (string.IsNullOrEmpty(Request["Token"])) ? "" : Request["Token"].ToString().Trim();
                SortMethod = (SortMethod == "+") ? "asc" : "desc";

                DataTable dt = new DataTable();
                if (com.VeriftyToken(token))
                {
                    n_db._P_CityNo = P_CityNo;
                    if (P_CityNo != "All")
                        dt = n_db.getPopulationList();
                    else
                        dt = n_db.getPopulation_All(SortName, SortMethod);
                    string xmlstr = string.Empty;
                    xmlstr = DataTableToXml.ConvertDatatableToXML(dt, "dataList", "data_item");
                    xmlstr = "<?xml version='1.0' encoding='utf-8'?><root>" + xmlstr + "</root>";
                    xDoc.LoadXml(xmlstr);
                }
                else
                {
                    xDoc = ExceptionUtil.GetTokenErrorMassageDocument();
                    Response.ContentType = System.Net.Mime.MediaTypeNames.Text.Xml;
                    xDoc.Save(Response.Output);
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
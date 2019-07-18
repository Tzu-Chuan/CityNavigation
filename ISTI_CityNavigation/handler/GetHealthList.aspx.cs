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
    public partial class GetHealthList : System.Web.UI.Page
    {
        Health_DB n_db = new Health_DB();
        protected void Page_Load(object sender, EventArgs e)
        {
            ///-----------------------------------------------------
            ///功    能: 撈健康列表
            ///-----------------------------------------------------
            XmlDocument xDoc = new XmlDocument();
            try
            {
                string Hea_CityNo = (Request["CityNo"] != null) ? Request["CityNo"].ToString().Trim() : "";
                string SortName = (Request["SortName"] != null) ? Request["SortName"].ToString().Trim() : "";
                string SortMethod = (Request["SortMethod"] != null) ? Request["SortMethod"].ToString().Trim() : "-";
                string token = (string.IsNullOrEmpty(Request["Token"])) ? "" : Request["Token"].ToString().Trim();
                SortMethod = (SortMethod == "+") ? "asc" : "desc";

                DataTable dt = new DataTable();
                if (Common.VeriftyToken(token))
                {
                    n_db._Hea_CityNo = Hea_CityNo;
                    if (Hea_CityNo != "All")
                        dt = n_db.getHealthList();
                    else
                        dt = n_db.getHealth_All(SortName, SortMethod);
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
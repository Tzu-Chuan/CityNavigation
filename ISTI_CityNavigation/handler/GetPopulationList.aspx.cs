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
        protected void Page_Load(object sender, EventArgs e)
        {
            ///-----------------------------------------------------
            ///功    能: 撈全國人口列表
            ///-----------------------------------------------------
            XmlDocument xDoc = new XmlDocument();
            try
            {
                string P_CityNo = (Request["CityNo"] != null) ? Request["CityNo"].ToString().Trim() : "";
                string sortName = (Request["sortName"] != null) ? Request["sortName"].ToString().Trim() : "";
                string sortMethod = (Request["sortMethod"] != null) ? Request["sortMethod"].ToString().Trim() : "";

                n_db._P_CityNo = P_CityNo;
                DataTable dt = n_db.getPopulationList(sortName, sortMethod);
                string xmlstr = string.Empty;
                xmlstr = DataTableToXml.ConvertDatatableToXML(dt, "dataList", "data_item");
                xmlstr = "<?xml version='1.0' encoding='utf-8'?><root>" + xmlstr + "</root>";
                xDoc.LoadXml(xmlstr);
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
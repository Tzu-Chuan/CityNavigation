using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Xml;

namespace ISTI_CityNavigation.handler
{
    public partial class GetBudgetExecution : System.Web.UI.Page
    {
        BudgetExecution_DB be_db = new BudgetExecution_DB();
        protected void Page_Load(object sender, EventArgs e)
        {
            ///-----------------------------------------------------
            ///功    能: 查詢預計經費執行情形
            ///說    明:
            ///-----------------------------------------------------
            XmlDocument xDoc = new XmlDocument();
            try
            {
                string xmlstr = string.Empty;

                DataTable dt = be_db.getBudgetExecution();
                
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
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using NPOI.SS.UserModel;//-- v.1.2.4起 新增的。
using NPOI.XSSF.UserModel;//-- XSSF 用來產生Excel 2007檔案（.xlsx）
using System.Text;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;

namespace ISTI_CityNavigation.Manage.mHandler
{
    public partial class ImportEnergy : System.Web.UI.Page
    {
        Energy_DB EN_DB = new Energy_DB();
        //建立共用參數
        string strErrorMsg = "";
        int strMaxVersion = 0;
        string chkYear = "";
        DateTime dtNow = DateTime.Now;
        protected void Page_Load(object sender, EventArgs e)
        {
            //讀取Token值
            string token = (string.IsNullOrEmpty(Request.Form["mToken"])) ? "" : Request.Form["mToken"].ToString().Trim();
            if (VeriftyToken(token))
            {
                //建立共用connection & transaction
                SqlConnection oConn = new SqlConnection(ConfigurationManager.AppSettings["ConnectionString"].ToString());
                oConn.Open();
                SqlCommand oCmd = new SqlCommand();
                oCmd.Connection = oConn;
                SqlTransaction myTrans = oConn.BeginTransaction();
                oCmd.Transaction = myTrans;

                //建立DataTable Bulk Copy用
                DataTable dt = new DataTable();
                dt.Columns.Add("Ene_CityNo", typeof(string));
                dt.Columns.Add("Ene_CityName", typeof(string));
                dt.Columns.Add("Ene_DeviceCapacityNumYear", typeof(string));
                dt.Columns.Add("Ene_DeviceCapacityNum", typeof(string));
                dt.Columns.Add("Ene_TPCBuyElectricityYear", typeof(string));
                dt.Columns.Add("Ene_TPCBuyElectricity", typeof(string));
                dt.Columns.Add("Ene_ElectricityUsedYear", typeof(string));
                dt.Columns.Add("Ene_ElectricityUsed", typeof(string));
                dt.Columns.Add("Ene_ReEnergyOfElectricityRateYear", typeof(string));
                dt.Columns.Add("Ene_ReEnergyOfElectricityRate", typeof(string));
                dt.Columns.Add("Ene_CreateDate", typeof(DateTime));
                dt.Columns.Add("Ene_CreateID", typeof(string));
                dt.Columns.Add("Ene_CreateName", typeof(string));
                dt.Columns.Add("Ene_Status", typeof(string));
                dt.Columns.Add("Ene_Version", typeof(int));

                try
                {
                    HttpFileCollection uploadFiles = Request.Files;//檔案集合
                    HttpPostedFile aFile = uploadFiles[0];
                    //判斷有沒有檔案
                    if (uploadFiles.Count < 1 || aFile.FileName == "")
                    {
                        throw new Exception("請選擇檔案");
                    }

                    //有檔案繼續往下做
                    if (uploadFiles.Count > 0)
                    {
                        string extension = (System.IO.Path.GetExtension(aFile.FileName) == "") ? "" : System.IO.Path.GetExtension(aFile.FileName);
                        if (extension != ".xls" && extension != ".xlsx")
                        {
                            throw new Exception("請選擇xls或xlsx檔案上傳");
                        }

                        IWorkbook workbook;// = new HSSFWorkbook();//创建Workbook对象
                        workbook = new XSSFWorkbook(aFile.InputStream);

                        ISheet sheet = workbook.GetSheetAt(0);//當前sheet

                        //簡易判斷這份Excel是不是能源的Excel
                        int cellsCount = sheet.GetRow(0).Cells.Count;
                        //1.判斷表頭欄位數
                        if (cellsCount != 5)
                        {
                            throw new Exception("請檢查是否為能源的匯入檔案");
                        }
                        //2.檢查欄位名稱
                        if (sheet.GetRow(0).GetCell(1).ToString().Trim() != "再生能源裝置容量數" || sheet.GetRow(0).GetCell(2).ToString().Trim() != "台電購入再生能源電量")
                        {
                            throw new Exception("請檢查是否為能源的匯入檔案");
                        }

                        //取得當前最大版次 (+1變成現在版次)
                        strMaxVersion = EN_DB.getMaxVersin() + 1;

                        //取得代碼檔
                        CodeTable_DB code_db = new CodeTable_DB();
                        DataTable dtCode = code_db.getCommonCode("02");

                        string cityNo = string.Empty;

                        //資料從第四筆開始 最後一筆是合計不進資料庫
                        for (int j = 3; j < sheet.PhysicalNumberOfRows - 1; j++)
                        {
                            if (sheet.GetRow(j).GetCell(0).ToString().Trim() != "" && sheet.GetRow(j).GetCell(0).ToString().Trim() != "全台平均")
                            {
                                DataRow row = dt.NewRow();
                                cityNo = Common.GetCityCodeItem(dtCode, sheet.GetRow(j).GetCell(0).ToString().Trim());//縣市代碼
                                if (cityNo == "")
                                {
                                    throw new Exception("第" + (j + 1) + "筆資料：" + sheet.GetRow(j).GetCell(0).ToString().Trim() + "不是一個正確的縣市名稱");
                                }
                                row["Ene_CityNo"] = cityNo;//縣市代碼
                                row["Ene_CityName"] = sheet.GetRow(j).GetCell(0).ToString().Trim();//縣市名稱
                                row["Ene_DeviceCapacityNumYear"] = sheet.GetRow(1).GetCell(1).ToString().Trim().Replace("年", "");//再生能源裝置容量數-資料年度(民國年)
                                row["Ene_DeviceCapacityNum"] = sheet.GetRow(j).GetCell(1).ToString().Trim();//再生能源裝置容量數-千瓦
                                row["Ene_TPCBuyElectricityYear"] = sheet.GetRow(1).GetCell(2).ToString().Trim().Replace("年", "");//台電購入再生能源電量-資料年度(民國年)
                                row["Ene_TPCBuyElectricity"] = sheet.GetRow(j).GetCell(2).ToString().Trim();//台電購入再生能源電量-度
                                row["Ene_ElectricityUsedYear"] = sheet.GetRow(1).GetCell(3).ToString().Trim().Replace("年", "");//用電量-資料年度(民國年)
                                row["Ene_ElectricityUsed"] = sheet.GetRow(j).GetCell(3).ToString().Trim();//用電量-度
                                row["Ene_ReEnergyOfElectricityRateYear"] = sheet.GetRow(1).GetCell(4).ToString().Trim().Replace("年", "");//再生能源電量佔用電量比例-資料年度(民國年)
                                row["Ene_ReEnergyOfElectricityRate"] = sheet.GetRow(j).GetCell(4).ToString().Trim();//再生能源電量佔用電量比例-%
                                row["Ene_CreateDate"] = dtNow;
                                row["Ene_CreateID"] = LogInfo.mGuid;//上傳者GUID
                                row["Ene_CreateName"] = LogInfo.name;//上傳者姓名
                                row["Ene_Status"] = "A";
                                row["Ene_Version"] = strMaxVersion;

                                if (chkYear == "")
                                    chkYear = sheet.GetRow(1).GetCell(1).ToString().Trim().Replace("年", "");

                                dt.Rows.Add(row);
                            }

                        }

                        if (dt.Rows.Count > 0)
                        {
                            BeforeBulkCopy(oConn, myTrans, chkYear);//檢查資料表裡面是不是有該年的資料
                            DoBulkCopy(myTrans, dt, strErrorMsg);//匯入
                                                                 //最後再commit
                            myTrans.Commit();
                            if (strErrorMsg == "")
                            {
                                strErrorMsg = "上傳成功";
                            }

                        }
                    }

                }
                catch (Exception ex)
                {
                    strErrorMsg += ex.Message;
                    myTrans.Rollback();
                }
                finally
                {
                    oCmd.Connection.Close();
                    oConn.Close();
                    Response.Write("<script type='text/JavaScript'>parent.feedbackFun('" + strErrorMsg.Replace("'", "") + "');</script>");
                }
            }
            else
            {
                strErrorMsg = "連線失敗請重新登入";
                Response.Write("<script type='text/JavaScript'>parent.feedbackFun('" + strErrorMsg.Replace("'", "") + "');</script>");
            }
        }
        //insert 前判斷是不是同年份有資料了
        private void BeforeBulkCopy(SqlConnection oConn, SqlTransaction oTran, string chkYear)
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(@"
                declare @chkRowCount int = 0;
                select @chkRowCount = count(*) from Energy where Ene_DeviceCapacityNumYear=@chkYear and Ene_Status='A'

                if @chkRowCount>0
                    begin
                        update Energy set Ene_Status='D' where Ene_DeviceCapacityNumYear=@chkYear and Ene_Status='A'
                    end
            ");
            SqlCommand oCmd = oConn.CreateCommand();
            oCmd.CommandText = sb.ToString();

            oCmd.Parameters.AddWithValue("@chkYear", chkYear);

            oCmd.Transaction = oTran;
            oCmd.ExecuteNonQuery();
        }

        //能源 BulkCopy
        private void DoBulkCopy(SqlTransaction oTran, DataTable srcData, string errorMsg)
        {
            try
            {
                SqlBulkCopyOptions setting = SqlBulkCopyOptions.CheckConstraints | SqlBulkCopyOptions.TableLock;
                using (SqlBulkCopy sqlBC = new SqlBulkCopy(oTran.Connection, setting, oTran))
                {
                    sqlBC.BulkCopyTimeout = 600; ///設定逾時的秒數
                    //sqlBC.BatchSize = 1000; ///設定一個批次量寫入多少筆資料, 設定值太小會影響效能 
                    ////設定 NotifyAfter 屬性，以便在每複製 10000 個資料列至資料表後，呼叫事件處理常式。
                    //sqlBC.NotifyAfter = 10000;
                    ///設定要寫入的資料庫
                    sqlBC.DestinationTableName = "Energy";

                    /// 對應來源與目標資料欄位 左邊：C# DataTable欄位  右邊：資料庫Table欄位
                    sqlBC.ColumnMappings.Add("Ene_CityNo", "Ene_CityNo");
                    sqlBC.ColumnMappings.Add("Ene_CityName", "Ene_CityName");
                    sqlBC.ColumnMappings.Add("Ene_DeviceCapacityNumYear", "Ene_DeviceCapacityNumYear");
                    sqlBC.ColumnMappings.Add("Ene_DeviceCapacityNum", "Ene_DeviceCapacityNum");
                    sqlBC.ColumnMappings.Add("Ene_TPCBuyElectricityYear", "Ene_TPCBuyElectricityYear");
                    sqlBC.ColumnMappings.Add("Ene_TPCBuyElectricity", "Ene_TPCBuyElectricity");
                    sqlBC.ColumnMappings.Add("Ene_ElectricityUsedYear", "Ene_ElectricityUsedYear");
                    sqlBC.ColumnMappings.Add("Ene_ElectricityUsed", "Ene_ElectricityUsed");
                    sqlBC.ColumnMappings.Add("Ene_ReEnergyOfElectricityRateYear", "Ene_ReEnergyOfElectricityRateYear");
                    sqlBC.ColumnMappings.Add("Ene_ReEnergyOfElectricityRate", "Ene_ReEnergyOfElectricityRate");
                    sqlBC.ColumnMappings.Add("Ene_CreateDate", "Ene_CreateDate");
                    sqlBC.ColumnMappings.Add("Ene_CreateID", "Ene_CreateID");
                    sqlBC.ColumnMappings.Add("Ene_CreateName", "Ene_CreateName");
                    sqlBC.ColumnMappings.Add("Ene_Status", "Ene_Status");
                    sqlBC.ColumnMappings.Add("Ene_Version", "Ene_Version");

                    /// 開始寫入資料
                    sqlBC.WriteToServer(srcData);
                }
            }
            catch (Exception ex)
            {
                strErrorMsg += "能源匯入 error：" + ex.Message.ToString() + "\n";
            }

        }

        //判斷Token是否正確
        private bool VeriftyToken(string clientToken)
        {
            if (string.IsNullOrEmpty(clientToken)) return false;

            string serverToken = HttpContext.Current.Session["Token"].ToString();
            if (clientToken.Equals(serverToken))
                return true;
            else
                return false;
        }
    }
}
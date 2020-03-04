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
    public partial class ImportHealth : System.Web.UI.Page
    {
        Health_DB HE_DB = new Health_DB();
        ImportData_Log idl_db = new ImportData_Log();
        //建立共用參數
        string strErrorMsg = "";
        int strMaxVersion = 0;
        DateTime dtNow = DateTime.Now;
        protected void Page_Load(object sender, EventArgs e)
        {
            //讀取Token值
            string token = (string.IsNullOrEmpty(Request["InfoToken"])) ? "" : Request["InfoToken"].ToString().Trim();
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
                dt.Columns.Add("Hea_CityNo", typeof(string)).MaxLength = 2;
                dt.Columns.Add("Hea_CityName", typeof(string)).MaxLength = 10;
                dt.Columns.Add("Hea_10KPeopleBedYear", typeof(string)).MaxLength = 3;
                dt.Columns.Add("Hea_10KPeopleBed", typeof(string)).MaxLength = 20;
                dt.Columns.Add("Hea_10KPeopleAcuteGeneralBedYear", typeof(string)).MaxLength = 3;
                dt.Columns.Add("Hea_10KPeopleAcuteGeneralBed", typeof(string)).MaxLength = 20;
                dt.Columns.Add("Hea_10KpeoplePractitionerYear", typeof(string)).MaxLength = 3;
                dt.Columns.Add("Hea_10KpeoplePractitioner", typeof(string)).MaxLength = 20;
                dt.Columns.Add("Hea_DisabledPersonOfCityRateYear", typeof(string)).MaxLength = 3;
                dt.Columns.Add("Hea_DisabledPersonOfCityRate", typeof(string)).MaxLength = 50;
                dt.Columns.Add("Hea_LongTermPersonYear", typeof(string)).MaxLength = 3;
                dt.Columns.Add("Hea_LongTermPerson", typeof(string)).MaxLength = 20;
                dt.Columns.Add("Hea_LongTermPersonOfOldMenRateYear", typeof(string)).MaxLength = 3;
                dt.Columns.Add("Hea_LongTermPersonOfOldMenRate", typeof(string)).MaxLength = 50;
                dt.Columns.Add("Hea_MedicalInstitutionsYear", typeof(string)).MaxLength = 3;
                dt.Columns.Add("Hea_MedicalInstitutions", typeof(string)).MaxLength = 20;
                dt.Columns.Add("Hea_MedicalInstitutionsAvgPersonYear", typeof(string)).MaxLength = 3;
                dt.Columns.Add("Hea_MedicalInstitutionsAvgPerson", typeof(string)).MaxLength = 20;
                dt.Columns.Add("Hea_GOVPayOfNHIYear", typeof(string)).MaxLength = 3;
                dt.Columns.Add("Hea_GOVPayOfNHI", typeof(string)).MaxLength = 20;
                dt.Columns.Add("Hea_DementedPopulationYear", typeof(string)).MaxLength = 3;
                dt.Columns.Add("Hea_DementedPopulation", typeof(string)).MaxLength = 50;
                dt.Columns.Add("Hea_DiabetesDeathsYear", typeof(string)).MaxLength = 3;
                dt.Columns.Add("Hea_DiabetesDeaths", typeof(string)).MaxLength = 50;
                dt.Columns.Add("Hea_CreateDate", typeof(DateTime));
                dt.Columns.Add("Hea_CreateID", typeof(string));
                dt.Columns.Add("Hea_CreateName", typeof(string));
                dt.Columns.Add("Hea_Status", typeof(string));
                dt.Columns.Add("Hea_Version", typeof(int));

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

                        //簡易判斷這份Excel是不是健康的Excel
                        int cellsCount = sheet.GetRow(0).Cells.Count;
                        //1.判斷表頭欄位數
                        if (cellsCount != 12)
                        {
                            throw new Exception("請檢查是否為健康的匯入檔案");
                        }
                        //2.檢查欄位名稱
                        if (sheet.GetRow(0).GetCell(1).ToString().Trim() != "每萬人口病床數" || sheet.GetRow(0).GetCell(2).ToString().Trim() != "每萬人口急性一般病床數")
                        {
                            throw new Exception("請檢查是否為健康的匯入檔案");
                        }

                        //取得當前最大版次 (+1變成現在版次)
                        strMaxVersion = HE_DB.getMaxVersin() + 1;

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

                                strErrorMsg = "行數:第" + (j + 1).ToString() + " 筆<br>";
                                row["Hea_CityNo"] = cityNo;//縣市代碼
                                row["Hea_CityName"] = sheet.GetRow(j).GetCell(0).ToString().Trim();//縣市名稱
                                row["Hea_10KPeopleBedYear"] = sheet.GetRow(1).GetCell(1).ToString().Trim().Replace("年", "");//每萬人口病床數-資料年度(民國年)
                                row["Hea_10KPeopleBed"] = sheet.GetRow(j).GetCell(1).ToString().Trim();//每萬人口病床數-床
                                row["Hea_10KPeopleAcuteGeneralBedYear"] = sheet.GetRow(1).GetCell(2).ToString().Trim().Replace("年", "");//每萬人口急性一般病床數-資料年度(民國年)
                                row["Hea_10KPeopleAcuteGeneralBed"] = sheet.GetRow(j).GetCell(2).ToString().Trim();//每萬人口急性一般病床數-床
                                row["Hea_10KpeoplePractitionerYear"] = sheet.GetRow(1).GetCell(3).ToString().Trim().Replace("年", "");//每萬人執業醫事人員數-資料年度(民國年)
                                row["Hea_10KpeoplePractitioner"] = sheet.GetRow(j).GetCell(3).ToString().Trim();//每萬人執業醫事人員數-人
                                row["Hea_DisabledPersonOfCityRateYear"] = sheet.GetRow(1).GetCell(4).ToString().Trim().Replace("年", "");//身心障礙人口占全縣(市)總人口比率-資料年度(民國年)
                                row["Hea_DisabledPersonOfCityRate"] = sheet.GetRow(j).GetCell(4).ToString().Trim();//身心障礙人口占全縣(市)總人口比率-%
                                row["Hea_LongTermPersonYear"] = sheet.GetRow(1).GetCell(5).ToString().Trim().Replace("年", "");//長期照顧機構可供進駐人數-資料年度(民國年)
                                row["Hea_LongTermPerson"] = sheet.GetRow(j).GetCell(5).ToString().Trim();//長期照顧機構可供進駐人數-人
                                row["Hea_LongTermPersonOfOldMenRateYear"] = sheet.GetRow(1).GetCell(6).ToString().Trim().Replace("年", "");//長期照顧機構可供進駐人數佔預估失能老人需求比例-資料年度(民國年)
                                row["Hea_LongTermPersonOfOldMenRate"] = sheet.GetRow(j).GetCell(6).ToString().Trim();//長期照顧機構可供進駐人數佔預估失能老人需求比例-%
                                row["Hea_MedicalInstitutionsYear"] = sheet.GetRow(1).GetCell(7).ToString().Trim().Replace("年", "");//醫療機構數-資料年度(民國年)
                                row["Hea_MedicalInstitutions"] = sheet.GetRow(j).GetCell(7).ToString().Trim();//醫療機構數-所
                                row["Hea_MedicalInstitutionsAvgPersonYear"] = sheet.GetRow(1).GetCell(8).ToString().Trim().Replace("年", "");//平均每一醫療機構服務人數-資料年度(民國年)
                                row["Hea_MedicalInstitutionsAvgPerson"] = sheet.GetRow(j).GetCell(8).ToString().Trim();//平均每一醫療機構服務人數-人/所
                                row["Hea_GOVPayOfNHIYear"] = sheet.GetRow(1).GetCell(9).ToString().Trim().Replace("年", "");//政府部門醫療保健支出-資料年度(民國年)
                                row["Hea_GOVPayOfNHI"] = sheet.GetRow(j).GetCell(9).ToString().Trim();//政府部門醫療保健支出-千元
                                row["Hea_DementedPopulationYear"] = sheet.GetRow(1).GetCell(10).ToString().Trim().Replace("年", "");//失智人口-資料年度(民國年)
                                row["Hea_DementedPopulation"] = sheet.GetRow(j).GetCell(10).ToString().Trim();//失智人口-人
                                row["Hea_DiabetesDeathsYear"] = sheet.GetRow(1).GetCell(11).ToString().Trim().Replace("年", "");//糖尿病死亡人數-資料年度(民國年)
                                row["Hea_DiabetesDeaths"] = sheet.GetRow(j).GetCell(11).ToString().Trim();//糖尿病死亡人數-人
                                row["Hea_CreateDate"] = dtNow;
                                row["Hea_CreateID"] = LogInfo.mGuid;//上傳者GUID
                                row["Hea_CreateName"] = LogInfo.name;//上傳者姓名
                                row["Hea_Status"] = "A";
                                row["Hea_Version"] = strMaxVersion;

                                dt.Rows.Add(row);
                            }

                        }

                        if (dt.Rows.Count > 0)
                        {
                            strErrorMsg = "";
                            BeforeBulkCopy(oConn, myTrans);//檢查資料表裡面是不是有該年的資料
                            DoBulkCopy(myTrans, dt);//匯入
                            myTrans.Commit();      //最後再commit
                        }
                    }

                }
                catch (Exception ex)
                {
                    strErrorMsg += "錯誤訊息:" + ex.Message + "<br>";
                    strErrorMsg += "(欄位名稱請參考上傳範例檔)";
                    myTrans.Rollback();
                }
                finally
                {
                    oCmd.Connection.Close();
                    oConn.Close();

                    if (strErrorMsg == "")
                    {
                        /// Log
                        idl_db._IDL_Type = "ISTI";
                        idl_db._IDL_IP = Common.GetIPv4Address();
                        idl_db._IDL_Description = "檔案類別:健康 , 狀態：上傳成功";
                        idl_db._IDL_ModId = LogInfo.mGuid;
                        idl_db._IDL_ModName = LogInfo.name;
                        idl_db.addLog();
                        Response.Write("<script type='text/JavaScript'>parent.feedbackFun('健康匯入成功');</script>");
                    }
                    else
                    {
                        /// Log
                        idl_db._IDL_Type = "ISTI";
                        idl_db._IDL_IP = Common.GetIPv4Address();
                        idl_db._IDL_Description = "檔案類別:健康 , 狀態：上傳失敗";
                        idl_db._IDL_ModId = LogInfo.mGuid;
                        idl_db._IDL_ModName = LogInfo.name;
                        idl_db.addLog();
                        Response.Write("<script type='text/JavaScript'>parent.feedbackFun('" + strErrorMsg.Replace("'", "") + "');</script>");
                    }
                }
            }
            else
            {
                strErrorMsg = "連線失敗請重新登入";
                Response.Write("<script type='text/JavaScript'>parent.feedbackFun('" + strErrorMsg.Replace("'", "") + "');</script>");
            }
        }

        //insert 前判斷是不是同年份有資料了
        private void BeforeBulkCopy(SqlConnection oConn, SqlTransaction oTran)
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(@"
                declare @chkRowCount int = 0;
                select @chkRowCount = count(*) from Health where Hea_Status='A'

                if @chkRowCount>0
                    begin
                        update Health set Hea_Status='D' where Hea_Status='A'
                    end
            ");
            SqlCommand oCmd = oConn.CreateCommand();
            oCmd.CommandText = sb.ToString();

            oCmd.Transaction = oTran;
            oCmd.ExecuteNonQuery();
        }

        //健康 BulkCopy
        private void DoBulkCopy(SqlTransaction oTran, DataTable srcData)
        {
            SqlBulkCopyOptions setting = SqlBulkCopyOptions.CheckConstraints | SqlBulkCopyOptions.TableLock;
            using (SqlBulkCopy sqlBC = new SqlBulkCopy(oTran.Connection, setting, oTran))
            {
                sqlBC.BulkCopyTimeout = 600; ///設定逾時的秒數
                //sqlBC.BatchSize = 1000; ///設定一個批次量寫入多少筆資料, 設定值太小會影響效能 
                ////設定 NotifyAfter 屬性，以便在每複製 10000 個資料列至資料表後，呼叫事件處理常式。
                //sqlBC.NotifyAfter = 10000;
                ///設定要寫入的資料庫
                sqlBC.DestinationTableName = "Health";

                /// 對應來源與目標資料欄位 左邊：C# DataTable欄位  右邊：資料庫Table欄位
                sqlBC.ColumnMappings.Add("Hea_CityNo", "Hea_CityNo");
                sqlBC.ColumnMappings.Add("Hea_CityName", "Hea_CityName");
                sqlBC.ColumnMappings.Add("Hea_10KPeopleBedYear", "Hea_10KPeopleBedYear");
                sqlBC.ColumnMappings.Add("Hea_10KPeopleBed", "Hea_10KPeopleBed");
                sqlBC.ColumnMappings.Add("Hea_10KPeopleAcuteGeneralBedYear", "Hea_10KPeopleAcuteGeneralBedYear");
                sqlBC.ColumnMappings.Add("Hea_10KPeopleAcuteGeneralBed", "Hea_10KPeopleAcuteGeneralBed");
                sqlBC.ColumnMappings.Add("Hea_10KpeoplePractitionerYear", "Hea_10KpeoplePractitionerYear");
                sqlBC.ColumnMappings.Add("Hea_10KpeoplePractitioner", "Hea_10KpeoplePractitioner");
                sqlBC.ColumnMappings.Add("Hea_DisabledPersonOfCityRateYear", "Hea_DisabledPersonOfCityRateYear");
                sqlBC.ColumnMappings.Add("Hea_DisabledPersonOfCityRate", "Hea_DisabledPersonOfCityRate");
                sqlBC.ColumnMappings.Add("Hea_LongTermPersonYear", "Hea_LongTermPersonYear");
                sqlBC.ColumnMappings.Add("Hea_LongTermPerson", "Hea_LongTermPerson");
                sqlBC.ColumnMappings.Add("Hea_LongTermPersonOfOldMenRateYear", "Hea_LongTermPersonOfOldMenRateYear");
                sqlBC.ColumnMappings.Add("Hea_LongTermPersonOfOldMenRate", "Hea_LongTermPersonOfOldMenRate");
                sqlBC.ColumnMappings.Add("Hea_MedicalInstitutionsYear", "Hea_MedicalInstitutionsYear");
                sqlBC.ColumnMappings.Add("Hea_MedicalInstitutions", "Hea_MedicalInstitutions");
                sqlBC.ColumnMappings.Add("Hea_MedicalInstitutionsAvgPersonYear", "Hea_MedicalInstitutionsAvgPersonYear");
                sqlBC.ColumnMappings.Add("Hea_MedicalInstitutionsAvgPerson", "Hea_MedicalInstitutionsAvgPerson");
                sqlBC.ColumnMappings.Add("Hea_GOVPayOfNHIYear", "Hea_GOVPayOfNHIYear");
                sqlBC.ColumnMappings.Add("Hea_GOVPayOfNHI", "Hea_GOVPayOfNHI");
                sqlBC.ColumnMappings.Add("Hea_DementedPopulationYear", "Hea_DementedPopulationYear");
                sqlBC.ColumnMappings.Add("Hea_DementedPopulation", "Hea_DementedPopulation");
                sqlBC.ColumnMappings.Add("Hea_DiabetesDeathsYear", "Hea_DiabetesDeathsYear");
                sqlBC.ColumnMappings.Add("Hea_DiabetesDeaths", "Hea_DiabetesDeaths");
                sqlBC.ColumnMappings.Add("Hea_CreateDate", "Hea_CreateDate");
                sqlBC.ColumnMappings.Add("Hea_CreateID", "Hea_CreateID");
                sqlBC.ColumnMappings.Add("Hea_CreateName", "Hea_CreateName");
                sqlBC.ColumnMappings.Add("Hea_Status", "Hea_Status");
                sqlBC.ColumnMappings.Add("Hea_Version", "Hea_Version");

                /// 開始寫入資料
                sqlBC.WriteToServer(srcData);
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
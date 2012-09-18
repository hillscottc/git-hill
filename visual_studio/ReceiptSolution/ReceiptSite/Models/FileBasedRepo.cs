using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.IO;
using System.Configuration;
using System.Web.Mvc;

namespace ReceiptSite.Models
{
    //public class FileBasedRepo : IReceiptRepo
    //{

    //    private static string fullReceiptRoot = ConfigurationManager.AppSettings["FullReceiptRoot"];
    //    public static string webReceiptRoot = ConfigurationManager.AppSettings["WebReceiptRoot"];

    //    public string WebReceiptRoot { get { return webReceiptRoot; } }
    //    public string FullReceiptRoot { get { return fullReceiptRoot; } }

    //    public DirectoryInfo FullBlankDir { get { return new DirectoryInfo(fullReceiptRoot + "blanks"); } }
    //    public DirectoryInfo FullReceiptDir {  get { return new DirectoryInfo(fullReceiptRoot + "receipts"); } }

    //    public string WebBlankDirStr { get { return webReceiptRoot + "blanks\\"; } }
    //    public string WebReceiptDirStr { get { return webReceiptRoot + "receipts\\"; } }


    //    public List<FileInfo> BlankImages
    //    {
    //        get
    //        {
    //            var blankImages = new List<FileInfo>();
    //            foreach (FileInfo fi in FullBlankDir.EnumerateFiles())
    //            {
    //                blankImages.Add(fi);
    //            }
    //            return blankImages;
    //        }
    //    }

    //    public List<Receipt> Receipts
    //    {
    //        get
    //        {
    //            var receipts = new List<Receipt>();
    //            foreach (FileInfo fi in FullReceiptDir.EnumerateFiles())
    //            {
    //                receipts.Add(new Receipt{Name=fi.Name});
    //            }
    //            return receipts;
    //        }
    //    }


    //    public string Add(Receipt receipt)
    //    {
    //        throw new NotImplementedException();
    //    }
    //}
}
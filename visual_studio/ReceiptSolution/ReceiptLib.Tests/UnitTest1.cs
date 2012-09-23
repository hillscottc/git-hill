using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.IO;
using ReceiptLib;
using System.Diagnostics;
using log4net;
using log4net.Config;


namespace ReceiptLib.Tests
{
    [TestClass]
    public class UnitTest1
    {
        // i also added the ref to the Assembly, but still no luck
        private static readonly ILog log = LogManager.GetLogger(typeof(UnitTest1));

        /// <summary>
        ///Initialize() is called once during test execution before
        ///test methods in this test class are executed.
        ///</summary>
        [TestInitialize()]
        public void Initialize()
        {
            log.Info("testing......................");
        }

        [TestMethod]
        public void TestMethod1()
        {
            //DirectoryInfo appDir = ReceiptLib.ReceiptTool.GetAppDir();
            //log.Info("testing......................");
            //log.Info("THE APP DIR IS  " + appDir.FullName);
        }

    }
}

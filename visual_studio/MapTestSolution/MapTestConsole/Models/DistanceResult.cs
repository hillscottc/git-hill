//------------------------------------------------------------------------------
// <auto-generated>
//    This code was generated from a template.
//
//    Manual changes to this file may cause unexpected behavior in your application.
//    Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace MapTestConsole.Models
{
    using System;
    using System.Collections.Generic;
    
    public partial class DistanceResult
    {
        public int Id { get; set; }
        public double Distance { get; set; }
        public int FirstVendorTestResultId { get; set; }
        public int SecondVendorTestResultId { get; set; }
    
        public virtual VendorTestResult FirstVendorTestResult { get; set; }
        public virtual VendorTestResult SecondVendorTestResult { get; set; }
    }
}

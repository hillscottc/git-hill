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
    
    public partial class TestItem
    {
        public TestItem()
        {
            this.VendorTestResults = new HashSet<VendorTestResult>();
        }
    
        public int Id { get; set; }
        public string Address { get; set; }
        public int CampaignId { get; set; }
        public int ResellerId { get; set; }
    
        public virtual ICollection<VendorTestResult> VendorTestResults { get; set; }
    }
}
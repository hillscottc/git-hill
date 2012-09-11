using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;


namespace ReceiptSite.Models
{
    // This blank partial class exists only to add the Metadata.
    [MetadataType(typeof(ReceiptMetadata))]
    public partial class Receipt { }

    public class ReceiptMetadata
    {
        public int id { get; set; }
        public string Name { get; set; }

        [DisplayName("The text to write")]
        public string TextData { get; set; }

        [DisplayName("Modified Image")]
        public Nullable<int> ReceiptImageId { get; set; }

        [DisplayName("Blank Image")]
        public Nullable<int> BlankImageId { get; set; }

        public Nullable<bool> Active { get; set; }
        public Nullable<System.DateTime> CreateDate { get; set; }

        //[DisplayName("Blank Image")]
        //public virtual ImageBank ImageBank;

        //[DisplayName("Modified Image")]
        //public virtual ImageBank ImageBank1;
    }
}
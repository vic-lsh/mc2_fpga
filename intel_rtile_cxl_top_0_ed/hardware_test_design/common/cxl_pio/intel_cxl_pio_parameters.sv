// (C) 2001-2024 Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files from any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License Subscription 
// Agreement, Intel FPGA IP License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Intel and sold by 
// Intel or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


package intel_cxl_pio_parameters;
    parameter ENABLE_ONLY_DEFAULT_CONFIG= 0;
    parameter ENABLE_ONLY_PIO           = 0;
    parameter ENABLE_BOTH_DEFAULT_CONFIG_PIO = 1;
    parameter PFNUM_WIDTH               = 3;
    parameter VFNUM_WIDTH               = 12;
    parameter DATA_WIDTH                = 1024;
    parameter BAM_DATAWIDTH             = DATA_WIDTH;
    parameter DEVICE_FAMILY             = "Agilex";
    //parameter CXL_IO_DWIDTH = 256; // Data width for each channel
    //parameter CXL_IO_PWIDTH = 32;  // Prefix Width
    //parameter CXL_IO_CHWIDTH = 1;  // Prefix Width

endpackage
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "DcjSv4cazWNFeTq2LDzhR8VVA2vsU+D2FLr5cau2M2bJ+ymOMJzu0j4X+D7sDofwwnGT3dC9uPfUfqUyT+1JDqgoqF4+Hm1+DbOqZuomBxMc/3ubRV7jR7LhS90CAIiftZSupMkt7Z6NB7tsmbvAu3Uqtxlo+Ag4QRIgi49yVFsS2wB30qw4GeL5di6t6OjbvWcjLtKHJMZ/Vew3QCsc9aW8Cap9TcP/4lTkJB8MFThFxIAKJYYR+7D0jxmKyo9G9HqQAaXAnifSgOMZcWMAG3Pyv6i/5BwC2VuFu+Sl7StHQV0pkW/1uhMgi2yBtDoOVyUfJMa5th7aTIG+ls25sIIetRXMRDzZWUdk35V4VK6WBpk8BlKoVaDz3L3Uow4DzAc4Ul/Hv0BvoGZ+UJYbbk1nE0M/rWLJrcOwXGxLgWBnjwuDgVlZedTpzDmFr5XzryivmQIISVgwTdCAZlBZgOYn+r58R5Avp0v3NLQtX4dUHSF8r/R96HUpHuelCC6Ue+IiCYCJruwZ8cpDi6U/Vs/3lmlYGd5jUOBYKJhLRyHM1ijnXynbh2lBKfPDxdb4AJLXBr8Etp70GsmQIFkr5JP2D1+xD1lIdApUCWZw3k33iI//LtbP1yn1hSA6od9HxSwoP8d0gO5YGkckv6IJOtfrbjxTsHF4WRqesKmwCJO7z34YSEq82J179V8P08eRmnocbPRj/iArkkF3xbSyvYi3qBud0g5ktwNDFCsSSQe8LZFpXIiewh9MZP9X0ibfwRG9DEaMp006nHXJl+hJfSevZgNuJjqdfKkjTaCBOZI70rugmFPDt4qd72zv41eaqwwKPhMMPyqKh2A8mvGU10sl8CYxz2v9aB67VlZDhtCIFTQKtp3Mju/bNPXfPwarIWkty+y9vaPoUP9tjKN9XCJ/lYaKYieKmELurfA0qyNDT02Dk29C9X/bna2CNDY4hw92TquxlzRj9hvJwzZPc3MKFXPDsspwsCcoSyO7MUSpdB5tJGnD6rIgoQv3pO0I"
`endif
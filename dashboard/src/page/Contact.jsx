import React from "react";
import Navbar from "../components/Navbar";
import { Link } from "react-router-dom";
import { FaFacebook, FaPhone, FaEnvelope } from "react-icons/fa";
import { BiLogoInstagram } from "react-icons/bi";
import Foot from "../components/Foot";

const Contacts = () => {
  return (
   <div className="bg-gray-200 h-screen">
      <Navbar />
    <div className="container mx-auto p-5  ">
      <div className="flex flex-col items-center bg-gray-100 p-6 rounded-lg shadow-md">
        <img
          src="https://iili.io/2DAMRoJ.png"
          alt="Profile"
          className="w-40 h-40 rounded-full shadow-lg mb-4"
        />
        <h2 className="text-2xl font-semibold">ช่องทางการติดต่อ</h2>
       
        <div className="flex flex-col gap-3 mt-4">
          <Link
             to = "https://www.facebook.com/esanclub.kmutnb"
            className="flex items-center gap-2 text-blue-600 hover:underline"
          >
            <FaFacebook className="text-xl" /> ชมรมอีสาน มจพ. 
          </Link>
          <Link
             to ="https://www.instagram.com/esanclub.kmutnb/?fbclid=IwY2xjawIS4ShleHRuA2FlbQIxMAABHbiIG5ek2qjFeuZS2So0ZSRSAVh1esqiEpWf4uUSTAD6Tj-wmneLIMxalw_aem_lFta9sye1_yftLgiFtQbiw#"
            className="flex items-center gap-2 text-pink-600 hover:underline"
          >
            <BiLogoInstagram 
            className="text-xl" /> esanclub.kmutnb
          </Link>
          
        </div>
      </div>
      <Foot/>
    </div>
      </div>
  );
};

export default Contacts;

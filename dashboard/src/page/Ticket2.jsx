import React, { useState } from 'react';
import Navbar from '../components/NavbarAdmin';
import Foot from '../components/Foot';
import Swal from 'sweetalert2';
import axios from 'axios';

const Ticket= () => {
  const [ticketCount, setTicketCount] = useState(1);
  const ticketPrice =  69; 

  const handleIncrease = () => {
    setTicketCount(ticketCount + 1);
  };

  const handleDecrease = () => {
    if (ticketCount > 1) {
      setTicketCount(ticketCount - 1);
    }
  };

  const handleCheckout = async () => {
   try {
       // Show loading Swal while fetching the QR code
       Swal.fire({
           title: "กำลังโหลด",
           allowOutsideClick: false,
           didOpen: () => Swal.showLoading(),
       });

      const data = {
        amount: ticketCount * ticketPrice,
      };
       const res = await axios.post(`https://52.62.242.78/api/QRcode/seat`, data, { responseType: "text" });
       if (!res.data) {
           throw new Error("ไม่สามารถจองที่นั่งได้");
       }

       
       const imageUrl = res.data; // Base64 encoded QR code

       // Show the payment modal with the QR code and seat information
       Swal.fire({
           title: "ชำระเงิน",
           html: `
             
               <img src="${imageUrl}" alt="QR Code" class="w-64 h-64 mx-auto" />
               <p>กรุณาชำระเงินภายใน 15 นาที</p>
           `,
           showCancelButton: true,
           confirmButtonText: "ยืนยันการชำระเงิน",
           cancelButtonText: "ยกเลิก",
       }).then((result) => {
           if (result.isConfirmed) {
            const p =  ticketPrice*ticketCount.toString();
            const data1 = {
              quantity : ticketCount.toString(),
              price : p.toString(),
            };
             
               axios.post("https://52.62.242.78/api/create/seat/personal", data1)
                   .then((res) => {
                       if (res.status === 200) {
                           Swal.fire({
                               icon: "success",
                               title: "ชำระเงินสำเร็จ",
                               text: "คุณได้จองที่นั่งเรียบร้อยแล้ว!",
                           });
                       }
                   })
                   .catch((error) => {
                       console.error("Error sending seat booking data:", error);
                       Swal.fire({
                           icon: "error",
                           title: "ไม่สามารถบันทึกข้อมูลการจอง",
                           text: "เกิดข้อผิดพลาดในการบันทึกข้อมูลการจองที่นั่ง",
                       });
                   });
           } else {
               Swal.fire({
                   icon: "info",
                   title: "ยกเลิกการจอง",
                   text: "คุณยกเลิกการชำระเงิน",
               });
           }
       });
   } catch (error) {
       console.error("Error:", error);
       Swal.fire({
           icon: "error",
           title: "เกิดข้อผิดพลาด",
           text: "ไม่สามารถสร้าง QR code ได้",
       });
   }
};
    

  return (
   <>
     <Navbar />
     <div className="bg-neutral-200 py-6 h-min-screen">
     <div className="container mx-auto my-10">
    <div className="max-w-lg mx-auto my-10 p-6 bg-white shadow-lg rounded-lg">
      <h1 className="text-3xl font-bold text-center mb-6">บัตรบุคคลธรรมดา</h1>
      
      <div className="text-center mb-4">
        <img
            src="https://iili.io/2DAMRoJ.png"
            alt="ticket"
            className="w-48 h-48
            mx-auto"
        />
      </div>

      <div className="mb-6">
        <p className="text-xl">ราคาบัตร: {ticketPrice} บาท</p>
        <div className="flex items-center justify-center space-x-4 mt-4">
          <button
            onClick={handleDecrease}
            className="bg-gray-300 p-2 rounded-full"
          >
            -
          </button>
          <p className="text-2xl">{ticketCount}</p>
          <button
            onClick={handleIncrease}
            className="bg-gray-300 p-2 rounded-full"
          >
            +
          </button>
        </div>
      </div>

      <div className="text-center">
        <p className="text-lg">รวม: {ticketCount * ticketPrice} บาท</p>
        <button
          onClick={handleCheckout}
          className="mt-4 px-6 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600"
        >
          ชำระเงิน
        </button>
      </div>
    </div>
   </div>
    <Foot />
   </div>
   </>
  );
};

export default Ticket;

import  Navbar from '../components/Navbar';
import Foot from '../components/Foot';

export default function Registrationclosed() {
      return (
         <div>
               <Navbar />
               <div className="flex items-center justify-center h-screen bg-neutral-200">
      <div className="bg-white p-8 rounded-2xl shadow-lg text-center">
      <div className="flex justify-center mt-4 py-4">
                <img src="https://iili.io/2DarKog.png" alt="logo" />
              </div>
        <h1 className="text-4xl font-bold text-red-600">ปิดการลงทะเบียน</h1>
         <p className="mt-4 text-gray-700">งานพาแลง ครั้งที่ 45 จัดโดยชมรมอีสาน มหาวิทยาลัยเทคโนโลยีพระจอมเกล้าพระนครเหนือ</p>
        <p className="mt-4 text-gray-700">
          ขออภัย การลงทะเบียนเข้าร่วมงานได้ปิดลงแล้ว
        </p>
        <p className="mt-2 text-gray-500">ชมรมอีสานมจพ. ขอขอบคุณทุกท่านที่สนใจเข้าร่วมงาน หากต้องการซื้อพาข้าว สามารถซื้อได้ที่หน้างาน</p>
        <div className="mt-8">
          <a href="page/ticket" className="bg-red-600 text-white px-4 py-2 rounded-lg">เเสดงบัตรเข้า</a>
         </div>

      </div>

    </div>
    <Foot />
      </div>
      )
   }
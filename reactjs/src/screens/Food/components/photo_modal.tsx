import Modal from "../../../components/modal/modal";
import React, {ChangeEvent, useRef, useState} from "react";
import Links from "../../../utils/links";
import axios from "axios";
import {FoodModel} from "../../../models/food_model";

interface FileDetails {
    name: string;
    size: number;
    type: string;
}

interface Props {
    showModal: boolean;
    setShowModal: (value: React.SetStateAction<boolean>) => void;
    accessToken: string | null;
    uuid: string | null;
    setFood:  React.Dispatch<React.SetStateAction<FoodModel | null>>;
}

export default function PhotoModal({
                                       showModal,
                                       setShowModal,
                                       accessToken,
                                       uuid,
                                       setFood
                                   }: Props) {
    const [selectedFile, setSelectedFile] = useState<File | null>();
    const [uploadError, setUploadError] = useState<string | null>();
    const [fileDetails, setFileDetails] = useState<FileDetails | null>();
    const fileInputRef = useRef<HTMLInputElement>(null);


    const handleFileUpload = async () => {
        if (selectedFile) {
            const formData = new FormData();
            formData.append('image', selectedFile);
            try {
                const link: string = Links.foodLink(uuid);
                const response = await axios.put(link, formData, {
                    headers: {
                        'Content-Type': 'multipart/form-data',
                        Authorization: `Bearer ${accessToken}`,
                    },
                }).then((item) => {
                    setShowModal(false);
                    setFood(FoodModel.fromJson(item.data));
                    return item;
                })
                console.log('File uploaded successfully:', response.data);
            } catch (error) {
                console.error('Error uploading file:', error);
            }
        }
    };

    const uploadPic = (e: ChangeEvent<HTMLInputElement>) => {
        if (fileInputRef.current) {
            fileInputRef.current.click();
            const file = e.target.files?.[0] || null;
            if (file) {
                const validExtensions = ['image/jpeg', 'image/png', 'image/gif'];
                if (!validExtensions.includes(file.type)) {
                    setUploadError('فرمت فایل قابل قبول نیست!');
                    setSelectedFile(null);
                    setFileDetails(null);
                    return;
                } else {
                    setSelectedFile(file);
                    setUploadError(null);
                    setFileDetails({
                        name: file.name,
                        size: file.size,
                        type: file.type,
                    });

                }
            }
        }

    }


    return (
        <>
            <Modal show={showModal} handleClose={() => {
                setShowModal(false);
            }}>
                <h2>ویرایش تصویر</h2>
                <div className='row' style={{rowGap: "20px", flexDirection: 'column'}}>
                    <input type='file' hidden={true} ref={fileInputRef} onChange={uploadPic}/>
                    <button className='btn yellow-btn' type='button' style={{width: '100%'}}
                            onClick={() => {
                                if (fileInputRef.current) {
                                    fileInputRef.current.click();
                                }
                            }}>
                        آپلود تصویر
                    </button>
                    <p style={{fontSize: '12px'}}>
                        فرمت های قابل قبول: png, jpg, gif
                    </p>
                    {fileDetails ? <p style={{fontSize: '12px'}}>
                        نام فایل : {fileDetails?.name}
                    </p> : <></>}
                    {uploadError ? <p className='red-color' style={{fontSize: '12px'}}>
                        خطا : {uploadError}
                    </p> : <></>}
                    {selectedFile ? <button className='btn green-btn' style={{fontSize: "12px"}}
                                            onClick={handleFileUpload}>تایید</button> : <></>}
                </div>
            </Modal>

        </>
    )
}
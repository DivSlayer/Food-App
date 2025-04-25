import Modal from "../../../components/modal/modal";
import {useEffect, useState} from "react";
import FormGroup from "../../../components/forms/form-group";
import PriceFormatter from "../../../utils/price_formatter";

interface Props {
    showModal: boolean;
    setShowModal: (show: boolean) => void;
    handleAdd: ({name, price, details}: { name: string, price: string, details: string },) => Promise<void>;
    defaultValues: Record<string, any>;
    modalTitle?: string | null;
}

export default function AddSizeModal({showModal, setShowModal, handleAdd, defaultValues, modalTitle}: Props) {
    const [price, setPrice] = useState("0");
    const [name, setName] = useState("");
    const [details, setDetails] = useState("");

    useEffect(() => {
        console.log(defaultValues)
        const keys = Object.keys(defaultValues);
        if (keys.includes('name')) {
            setName(defaultValues['name']);
        }
        if (keys.includes('details')) {
            setDetails(defaultValues['details']);
        }
        if (keys.includes('price')) {
            updatePrice(String(defaultValues['price']));
        }
    }, []);

    const updatePrice = (value: string) => {
        value = value.replaceAll(/[^0-9]/g, '');
        let extractedNum = parseInt(value);
        if (!isNaN(extractedNum)) {
            setPrice(PriceFormatter(extractedNum));

        } else {
            setPrice('0');
        }

    }

    return (
        <>
            <Modal show={showModal} handleClose={() => {
                setShowModal(false);
                setPrice('0')
            }}>
                <h2>{modalTitle ?? 'اضافه کردن سایز'}</h2>
                <form className='form'
                      style={{
                          display: "flex",
                          "alignItems": "flex-start",
                          rowGap: "20px",
                          flexDirection: 'column',
                          width: '100%'
                      }}>
                    <FormGroup label="عنوان سایز" name="name" value={name}
                               update={(v) => {
                                   setName(v)
                               }}/>
                    <FormGroup label="اندازه" name="details" value={details}
                               update={(v) => {
                                   setDetails(v);
                               }}/>
                    <FormGroup label="قیمت (تومان)" name="price" value={price}
                               update={(v) => {
                                   updatePrice(v);
                               }}/>

                </form>
                <div className='row' style={{columnGap: "20px"}}>
                    <button className='btn green-btn' onClick={async () => {
                        await handleAdd({name, price, details});
                    }}>تایید
                    </button>
                </div>
            </Modal>
        </>
    )
}
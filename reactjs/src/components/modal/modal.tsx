// Modal.tsx
import React, { ReactNode } from 'react';
import ReactDOM from 'react-dom';
import './modal.scss';
import CloseIcon from '../../assets/svgs/close-outline.svg';

interface ModalProps {
    show: boolean;
    handleClose: () => void;
    children: ReactNode;
}

const Modal: React.FC<ModalProps> = ({ show, handleClose, children }) => {
    const showHideClassName = show ? "modal display-block" : "modal display-none";

    return ReactDOM.createPortal(
        <div className={showHideClassName}>
            <section className="modal-main">
                {children}
                <button onClick={handleClose} className='btn red-btn close-btn'>
                    <svg xmlns="http://www.w3.org/2000/svg" className="ionicon" viewBox="0 0 512 512">
                        <path fill="none" stroke="#fff" stroke-linecap="round" stroke-linejoin="round"
                              stroke-width="32" d="M368 368L144 144M368 144L144 368"/>
                    </svg>
                </button>
            </section>
        </div>,
        document.getElementById('modal-root')!
    );
};

export default Modal;

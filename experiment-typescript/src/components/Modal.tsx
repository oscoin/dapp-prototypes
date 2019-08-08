import ReactDOM from 'react-dom';
import React, { ReactNode } from 'react';

const Modal = (props: { children: ReactNode, onClose?: any }) =>
  ReactDOM.createPortal(
    <div className='modal'>
      {props.children}
      <div className='modal__close' onClick={props.onClose}>&times;</div>
    </div>,
    document.getElementById('modal-root') as HTMLElement
  )

export default Modal
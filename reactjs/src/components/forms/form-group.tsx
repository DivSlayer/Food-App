import React, {HTMLInputTypeAttribute, ReactElement, ReactNode, useEffect, useRef} from "react";

interface FormGroupProps {
    label: string;
    name: string;
    icon?: string | ReactElement | null;
    img?: string | null;
    keyboardType?: HTMLInputTypeAttribute;
    suffix?: string | null;
    value?: string | null;
    useTextarea?: boolean;
    useSelect?: boolean;
    children?: ReactNode;
    error?: string | null;

    suffixClick?(e: React.MouseEvent | React.TouchEvent): void;

    update?(value: string): void;
}

const FormGroup: React.FC<FormGroupProps> = ({
                                                 label,
                                                 icon = null,
                                                 img = null,
                                                 name,
                                                 keyboardType = 'text',
                                                 suffix = null,
                                                 suffixClick = (e) => {
                                                     e.preventDefault()
                                                 },
                                                 update = (value) => {
                                                 },
                                                 value = null,
                                                 useTextarea = false,
                                                 useSelect = false,
                                                 children = null,
                                                 error = null
                                             },) => {
    let labelRef = useRef<HTMLSpanElement>(null);
    let formRef = useRef<HTMLDivElement>(null);
    let inputRef = useRef<HTMLInputElement>(null);
    let textareaRef = useRef<HTMLTextAreaElement>(null);
    let selectRef = useRef<HTMLSelectElement>(null);

    function focusInput() {
        labelRef!.current!.classList.add('focused');
        formRef.current!.classList.add('focused');
        labelRef.current!.classList.remove('hidden');
    }

    function focusOutInput() {
        labelRef.current!.classList.remove('focused');
        formRef.current!.classList.remove('focused');
    }

    function valuedInput() {
        labelRef.current!.classList.add('valued');
        formRef.current!.classList.add('valued');
        if (!useSelect) {
            labelRef.current!.classList.remove('hidden');
        }
    }

    function notValuedInput() {
        labelRef.current!.classList.remove('valued');
        formRef.current!.classList.remove('valued');
        console.log('not valued')
        if (!useSelect) {
            // labelRef.current!.classList.add('hidden');
        }
    }

    useEffect(() => {
        let reference = inputRef.current ?? textareaRef.current;
        if (reference != null && labelRef.current != null && formRef.current != null) {
            if (!useSelect) {
                reference.addEventListener('focus', () => {
                    focusInput();
                })
                reference.addEventListener('keyup', () => {
                    let value = reference!.value;
                    if (value && value !== "") {
                        valuedInput();
                    } else {
                        notValuedInput();
                    }
                })
            }
            reference.addEventListener('blur', () => {
                focusOutInput();
            })
        }
        if (value !== null && value !== "") {
            valuedInput();
        } else {
            notValuedInput();
        }
    }, [value]);


    return (
        <div style={{width: '49%'}}>
            <div className='form-group' ref={formRef}>
                <span className={'label' + (useSelect ? " focused" : '')} ref={labelRef}
                      onClick={() => {
                          if (inputRef.current) {
                              inputRef.current.focus();
                          } else {
                              textareaRef.current!.focus();
                          }
                      }}>{label}</span>
                {useTextarea ? <textarea className='form-control input textarea' ref={textareaRef} name={name}
                                         onChange={(event) => {
                                             let value = event.currentTarget.value;
                                             update(value);
                                         }}>{value}</textarea> :
                    useSelect ?
                        <select className='form-control input select' ref={selectRef} name={name} onChange={(event) => {
                            let value = event.currentTarget.value;
                            update(value);
                        }}>
                            {children ?? <></>}

                        </select> :
                        <input type={keyboardType} className='form-control input' ref={inputRef} name={name}
                               autoComplete={'off'}
                               value={value ?? undefined}
                               onChange={(event) => {
                                   let value = event.currentTarget.value;
                                   update(value);
                               }}
                        />
                }

                {
                    icon ? icon : <></>
                }
                {
                    img ? <img src={img} alt='icon'/> : <></>
                }
                {
                    suffix ? <img onClick={suffixClick} src={suffix} alt='icon' className='suffix'/> : <></>
                }
            </div>
            {error != null ? <p className='error-text'>{error}</p> : <></>}
        </div>
    )
}

export default FormGroup
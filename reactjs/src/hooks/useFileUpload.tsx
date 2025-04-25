/*
File: src/hooks/useFileUpload.ts
Manages file selection and upload for images
*/
import React, { useRef, useState } from 'react';
import axios from 'axios';
import Links from '../utils/links';

interface FileDetails { name: string; size: number; type: string; }

export function useFileUpload(uuid: string, token: string) {
    const inputRef = useRef<HTMLInputElement>(null);
    const [details, setDetails] = useState<FileDetails | null>(null);
    const [error, setError] = useState<string | null>(null);
    const [file, setFile] = useState<File | null>(null);

    const select = () => inputRef.current?.click();

    const onChange = (e: React.ChangeEvent<HTMLInputElement>) => {
        const f = e.target.files?.[0] || null;
        if (!f) return;
        const valid = ['image/jpeg','image/png','image/gif'];
        if (!valid.includes(f.type)) {
            setError('فرمت فایل قابل قبول نیست!'); setFile(null); setDetails(null);
        } else {
            setError(null);
            setFile(f);
            setDetails({ name: f.name, size: f.size, type: f.type });
        }
    };

    const upload = async () => {
        if (!file) return;
        const form = new FormData(); form.append('image', file);
        const response = await axios.put(
            Links.foodLink(uuid), form,
            { headers: { Authorization: `Bearer ${token}`, 'Content-Type': 'multipart/form-data' } }
        );
        return response.data;
    };

    return { inputRef, details, error, file, select, onChange, upload };
}


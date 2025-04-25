import Links from "../utils/links";
import {AddressModel} from "../models/address_model";


export async function AddressBloc(accessToken: string, uuid?: string | null): Promise<AddressModel[] | null> {
    const link: string = Links.addressLink(uuid);
    const response = await fetch(link, {
        method: 'GET',
        headers: {
            Authorization: `Bearer ${accessToken}`,
        },
    });
    if (response.ok) {
        let json_converted = await response.json();
        let transaction_json_list: { [key: string]: any }[];
        transaction_json_list = json_converted['addresses'];
        return transaction_json_list.map((item) => {
            return AddressModel.fromJson(item);
        });
    }
    return null;
}
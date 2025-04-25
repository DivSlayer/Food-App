import Links from "../utils/links";
import {TransactionModel} from "../models/transaction_model";

export async function TransactionBloc(accessToken: string, serial?: string | null): Promise<TransactionModel[] | null> {
    const link: string = Links.transactionLink(serial) + (serial ? "" : "/");
    console.log(`Link is ${link}`);
    const response = await fetch(link, {
        method: 'GET',
        headers: {
            Authorization: `Bearer ${accessToken}`,
        },
    });
    if (response.ok) {
        let json_converted = await response.json();
        let transaction_json_list: { [key: string]: any }[];
        transaction_json_list = json_converted['transactions'];
        return transaction_json_list.map((item) => {
            return TransactionModel.fromJson(item);
        });
    }
    return null;
}
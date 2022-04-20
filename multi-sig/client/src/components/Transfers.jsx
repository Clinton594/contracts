import React from 'react'

export default function Transfers({state, sendApprover}) {
  return (
    <div>
      <table  border="1" width="100%" style={{marginTop:20}}>
        <thead>
          <tr>
            <th>S/N</th>
          <th>ID</th>
          <th>AMOUNT</th>
          <th>RECIPIENT</th>
          <th>CONFIRMATIONS</th>
          <th>STATUS</th>
          </tr>
        </thead>
        <tbody>
          {
            state.transfers.length > 0 && state.transfers.map((row, index)=>{
              return(
                <tr key={index + 1}>
                  <td>{index + 1}</td>
                  <td>{row.id}</td>
                  <td>{row.amount}</td>
                  <td>{row.receipient}</td>
                  <td>
                    {row.approvals} 
                    <select name={row.id} id="" style={{float:'right'}} onChange={(event)=>{sendApprover(event)}}>
                      {
                        state.approvers.length && (
                          state.approvers.map((approver, _index)=>(
                            <option key={_index} value={approver}>{_index}</option>
                          ))
                        )
                      }
                    </select>
                  </td>
                  <td>{row.sent ? "Yes":"No"}</td>
                </tr>
              )
            })
          }
        </tbody>
      </table>
    </div>
  )
}

{-# LANGUAGE TemplateHaskell #-}

module Types.Transaction where

import           Composite                         ((:->), Record)
import           Composite.Aeson.TH                (makeRecordJsonWrapper)
import           Composite.Opaleye                 (defaultRecTable)
import           Composite.Swagger.TH              (makeToSchema)
import           Composite.TH                      (withLensesAndProxies)
import           Control.Lens.TH                   (makeWrapped)
import           Data.Int                          (Int64)
import           Data.Text                         (Text)
import           Network.Ethereum.ABI.Prim.Address
import           Opaleye                           (Column, PGBytea, PGInt8,
                                                    PGText, Table (..))
import           Types.Orphans                     ()

--------------------------------------------------------------------------------
-- Raw Transactions
--------------------------------------------------------------------------------

withLensesAndProxies [d|
  type FTxHash      = "transactionHash" :-> Text
  type CTxHash      = "transactionHash" :-> Column PGText
  type FBlockNumber = "blockNumber"     :-> Int64
  type CBlockNumber = "blockNumber"     :-> Column PGInt8
  type FAddress     = "address"         :-> Address
  type CAddress     = "address"         :-> Column PGBytea
  |]

type ApiTransaction = '[FTxHash, FAddress, FBlockNumber]
type DBTransaction = '[FTxHash, FAddress, FBlockNumber]
type DBTransactionCols = '[CTxHash, CAddress, CBlockNumber]

transactionTable :: Table (Record DBTransactionCols) (Record DBTransactionCols)
transactionTable = Table "transactions" defaultRecTable

makeRecordJsonWrapper "ApiTransactionJson" ''ApiTransaction
makeWrapped ''ApiTransactionJson
makeToSchema "ApiTransactionJson" ''ApiTransactionJson

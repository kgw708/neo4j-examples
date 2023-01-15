#!bin/bash
set -euC

# EXTENSION_SCRIPTはdockerコンテナが起動する都度実行される
# そのため、importが実行されているかdoneファイルの存在有無により確認する
if [ -f /import/done ]; then
  echo 'skip import process'
  return
fi

# DB削除
echo 'start remove DB process'
rm -rf /data/databases
rm -rf /data/transactions
echo 'end remove DB process'

# データ投入
echo 'start import data process'
neo4j-admin database import full \
  --nodes=/import/nodes1.csv \
  --nodes=/import/nodes2.csv \
  --relationships=/import/relationships.csv neo4j
echo 'end import data process'

# import処理の完了を示すdoneファイルの作成
echo 'start create done file process'
touch /import/done
echo 'end create done file process'

# EXTENSION_SCRIPTはroot権限で実行される
# そのため、ディレクトリの所有者を変更する
echo 'start change owner process'
chown -R neo4j:neo4j /data
chown -R neo4j:neo4j /logs
echo 'end change owner process'

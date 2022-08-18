#合约结构设计
ResumeNft is ERC721, AccessControl（控制合约权限）

ResumeNft合约记录人才信息和企业信息，并生成相关接口，用于人才和企业的注册和信息修改

tokenId 使用钱包地址

修改tokenURI方法，使其返回值为address

创建工厂合约DlnFactory，ResumeNft合约中调用DlnFactory.createContract方法部署签约合同合约

并给工厂合约设置调用权限，只能由ResumeNft调用createContract方法部署签约合同合约

签约合同合约储存人才与企业签约信息


##签约流程：

1.用户调用授权操作，允许企业主体合约操作用户的NFT

2.企业调用合约中的签约方法与用户签约，并将用户的NFT转账到ResumeNft自身地址。同时调用工厂合约部署记录签约信息，并在工厂合约中记录签约合同合约地址。

3.ResumeNft自身地址集中持有所有已经签约的用户NFT，并允许指定管理账户持有在不经企业同意的情况下，解除合同并归还NFT给个人。

4.企业与用户解约时，企业通过调用ResumeNft中的解约方法，将NFT归还给用户，同时将对应的合同合约在工厂合约中去除。

public class Utility {
    public class ListUtil{
        public List<String> getColumnValues(List<sObject> sObjectList, String fieldApiName){
            List<String> columnValues = new List<String>();
            for(sObject sObj : sObjectList){
                columnValues.add(String.valueOf(sObj.get(fieldApiName)));
            }
            return columnValues;
        }
    }
    
    public class MapUtil{
        public Map<String, List<sObject>> getMapWithDifferentKey(List<sObject> sObjectList, String fieldApiName){
            Map<String, List<sObject>> mapWithDifferentKey = new Map<String, List<sObject>>();
            for(sObject sObj : sObjectList){
                String key = getKey(String.valueOf(sObj.get(fieldApiName)));
                sObject value = sObj;
                if(!mapWithDifferentKey.isEmpty() && mapWithDifferentKey.containsKey(key)){
                    List<sObject> sObjectValues = mapWithDifferentKey.get(key);
                    sObjectValues.add(sObj);
                }else{
                    mapWithDifferentKey.put(key, new List<sObject>{sObj});
                }
            }
            return mapWithDifferentKey;
        }
        private String getKey(String key){
            return String.isNotBlank(key) ? key : 'NoKey';
        }
    }
    
    public class ValidationUtil{
        public void validateBlankFields(sObject sObj, List<String> fieldApiNameList){
            String sObjectType = sObj.getSObjectType().getDescribe().getName();
            Map<String, Schema.SObjectField> fieldSchema = getFieldSchema(sObjectType);
            for(String fieldApiName : fieldApiNameList){
                if(String.isBlank(String.valueOf(sObj.get(fieldApiName)))){
                    sObj.addError(fieldSchema.get(fieldApiName).getDescribe().getLabel()+' is missing.');                    
                }                                
            }
        }
        private Map<String, Schema.SObjectField> getFieldSchema(String sObjectType){
            return Schema.getGlobalDescribe().get(sObjectType).getDescribe().fields.getMap();
        }
    }
}

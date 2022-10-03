const mongoose=require('mongoose');

const OptionSchema=new mongoose.Schema({
    option_id:{
        type:String, //mongoose.Schema.Types.ObjectId
        required:true
    },
    proposal_id:{type:mongoose.Schema.Types.ObjectId},
    title:{
        type:String,
        required:true
    },
    description:{
        type:String,
        required:true
    },
    count:{
        type:Number,
        default:0
    },
    voters:[
        {type:String} //array of addresses of voters
    ],
    
});

module.exports=mongoose.model('options',OptionSchema);
//ROUTE3: updating note: PUT: /api/notes/updatenote:id  --login reqq
router.put('/updatenote/:id',
    async (req,res)=>{

    try{
    
    const {title,description,ctc,deadline,location,role,cg,tenth,twelfth,branch}=req.body;
    //creating new note object:
    newNote={};
    if(title){newNote.title=title;}
    if(description){newNote.description=description;}
    if(ctc){newNote.ctc=ctc;}
    if(deadline){newNote.deadline=deadline;}
    if(location){newNote.location=location;}
    if(role){newNote.role=role;}
    if(cg){newNote.cg=cg;}
    if(tenth){newNote.tenth=tenth;}
    if(twelfth){newNote.twelfth=twelfth;}
    if(branch){newNote.branch=branch;}
    
    //find the note to be updated and update it:
    let note=await Notes.findById(req.params.id);

    //check if note exists or not:
    if(!note){
        return res.status(404).send("Note not found");
    }


    //now note exists and user is corretc:
    note=await Notes.findByIdAndUpdate(req.params.id,{$set:newNote},{new:true});
    res.json(note);
    }
    catch(err){
        console.log(err);
        res.status(500).send("Some error occured.");
    }
});

//ROUTE4: deleting a  note: DELETE: /api/notes/deletenote/:id  --login reqq
router.delete('/deletenote/:id',
    async (req,res)=>{

    try{
    
    //find the note to be deleted and delete it:
    let note=await Notes.findById(req.params.id);
    
    //check if note exists or not:
    if(!note){
        return res.status(404).send("Note not found");
    }

    //now note exists and user is corretc:
    note=await Notes.findByIdAndDelete(req.params.id);
    res.send({"Success":"Note deleted successfully",note:note});

    // let user=await Users.findById(req.user.id);
    // applnote=await user.appliedTo.findByIdAndDelete(req.params.id);
    }
    catch(err){
        console.log(err);
        res.status(500).send("Some error occured.");
    }
});

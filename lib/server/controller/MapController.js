//const db = require("../db_connect/db_user");
//const OSM = require('osm-api');
//
//exports.getFeature = async (req, res) => {
//  try {
//    const { id } = req.params;
//    const feature = await OSM.getFeature('way', id);
//    res.json(feature);
//  } catch (error) {
//    res.status(500).json({ error: error.message });
//  }
//};
//
//exports.createChangesetComment = async (req, res) => {
//  try {
//    const { changesetId, comment } = req.body;
//    const response = await OSM.createChangesetComment(changesetId, comment);
//    res.json(response);
//  } catch (error) {
//    res.status(500).json({ error: error.message });
//  }
//};